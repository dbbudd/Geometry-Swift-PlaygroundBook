//
//  ViewController.swift
//
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import UIKit
import WebKit
import PlaygroundSupport

@objc(SPCHypeCutSceneController)
open class SPCHypeCutSceneController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var pageLocation: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startCodingButton: UIButton!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var shadowView: UIView!
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        if case .backgroundOnly = scalingMode {
            let viewportJavaScript = "document.querySelector('meta[name=\"viewport\"]').content = \"\";"
            let viewportScript = WKUserScript(source: viewportJavaScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            
            let sizingCSS = "#resizableFill { background-image: linear-gradient(var(--gradient-top-bg-color), var(--gradient-bottom-bg-color)); position: fixed; top: 0; bottom: 0; left: 0; right: 0; } body > div[id$=\"container\"] { margin: -384px 0 0 -512px !important; top: 50% !important; left: 50% !important; width: 1024px !important; height: 768px !important; } #bgRectangle { display: none !important; } .HYPE_scene { background-color: transparent !important; background-image: none !important; }"
            let sizingJavaScript = "var fill = document.createElement('div'); fill.id = \"resizableFill\"; document.body.insertBefore(fill, document.body.firstChild); var style = document.createElement('style'); style.innerHTML = '\(sizingCSS)'; document.head.appendChild(style);"
            let sizingScript = WKUserScript(source: sizingJavaScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            
            let contentController = WKUserContentController()
            contentController.addUserScript(viewportScript)
            contentController.addUserScript(sizingScript)
            configuration.userContentController = contentController
        }
        
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.navigationDelegate = self
        view.scrollView.isScrollEnabled = false
        view.scrollView.panGestureRecognizer.isEnabled = false
        view.scrollView.bounces = false
        view.scrollView.bouncesZoom = false
        view.scrollView.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private let cutsceneWidth: CGFloat = 1366
    private let cutsceneHeight: CGFloat = 1024
    
    public enum ScalingMode {
        case traditional
        case backgroundOnly
        
        public static let platformDefault: ScalingMode = {
            #if targetEnvironment(macCatalyst)
            return .backgroundOnly
            #else
            return .traditional
            #endif
        }()
    }
    
    private var scalingMode: ScalingMode = .traditional
    
    private var buttonReadyTimer: Timer?
    
    public static func makeFromStoryboard(for cutSceneItem: SPCCutSceneItem, scaling scalingMode: ScalingMode = .platformDefault) -> SPCHypeCutSceneController {
        let storyboard = UIStoryboard(name: "SPCHypeCutSceneController", bundle: Bundle.main)
        let vc = storyboard.instantiateInitialViewController() as! SPCHypeCutSceneController
        vc.item = cutSceneItem
        vc.scalingMode = scalingMode
        return vc
    }
    
    
    public var item : SPCCutSceneItem? {
        didSet {
            guard let newItem = item else { return }
            self.title = newItem.name
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(macCatalyst)
        webView.accessibilityContainerType = .none
        #endif
                
        webView.isHidden = true
        view.insertSubview(webView, at: 0)
        switch scalingMode {
        case .traditional:
            webView.bounds = CGRect(x: 0, y: 0, width: cutsceneWidth, height: cutsceneHeight)
        case .backgroundOnly:
            webView.frame = view.bounds
        }
        
        webView.becomeFirstResponder()
                
        currentPage = 0
        
        view.backgroundColor = UIColor(named: "systemBackground") ?? .darkGray
        
        shadowView.isHidden = true
        effectView.layer.cornerRadius = 22.0
        effectView.layer.masksToBounds = true
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.15
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowRadius = 1
        
        if #available(iOS 13.0, *) {
            effectView.effect = UIBlurEffect(style: .systemThickMaterial)
        }
        
        startCodingButton.setTitle(NSLocalizedString("Start Coding", comment: "Start Coding"), for: .normal)
        
        // Temporary tintColor fix
        let fixedTintColor = UIButton().tintColor
        nextButton.tintColor = fixedTintColor
        prevButton.tintColor = fixedTintColor
        startCodingButton.setTitleColor(fixedTintColor, for: .normal)

        guard let scene = item else {
            fatalError("*** The scene was not attached.")
        }
        guard let url = scene.fileURLForSourcePath() else {
            fatalError("*** URL could not be found.")
        }

//        print("**** URL -- \(url)")
//        print("**** DIR -- \(scene.fileURLForSourceDirectory())")
        
        let resourceDirectory = scene.fileURLForSourceDirectory()
        let resourceLanguageDirectory = resourceDirectory.deletingLastPathComponent()
        let resourceGlobalDirectory = resourceLanguageDirectory.deletingLastPathComponent()
        webView.loadFileURL(url, allowingReadAccessTo: resourceGlobalDirectory)
        updatePageCounter(currentPage, of: scene.timeline.count)
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        switch scalingMode {
        case .traditional:
            let (xScale, yScale): (CGFloat, CGFloat) = {
                let scaleToFitWidth = view.bounds.width / cutsceneWidth
                let scaleToFitHeight = view.bounds.height / cutsceneHeight
                // Pick the smallest of the scales to "aspect fit"
                if scaleToFitHeight < scaleToFitWidth {
                    #if targetEnvironment(macCatalyst)
                    return (scaleToFitHeight, scaleToFitHeight)
                    #else
                    let calculatedWidth = scaleToFitHeight * cutsceneWidth
                    if calculatedWidth < view.bounds.width - 10 {
                        return (scaleToFitWidth, scaleToFitHeight)
                    }
                    else {
                        return (scaleToFitHeight, scaleToFitHeight)
                    }
                    #endif
                } else {
                    return (scaleToFitWidth, scaleToFitWidth)
                }
            }()
        
            let scaleTransform: CGAffineTransform
            if xScale == yScale && abs(xScale - 1.0) < 0.0001 {
                scaleTransform = CGAffineTransform.identity
            }
            else {
                scaleTransform = CGAffineTransform(scaleX: xScale, y: yScale)
            }
            webView.transform = scaleTransform
            webView.center = view.center
            
        case .backgroundOnly:
            webView.frame = view.bounds
            webView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
    }
    
    override public var keyCommands: [UIKeyCommand]? {
        let forward = UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(goForward(_:)))
        let back = UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(goBack(_:)))
        return [forward, back]
    }
    
    fileprivate func showWebView() {
        webView.alpha = 0
        shadowView.alpha = 0
        webView.isHidden = false
        shadowView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.webView.alpha = 1
            self.shadowView.alpha = 1
        })
    }
    
    // MARK: - Page Navigation
    
    fileprivate var currentPage = 0
    
    @IBAction func goBack(_ sender: Any) {
        guard currentPage - 1 >= 0 else { return }
        goto(page: currentPage - 1)
    }
    
    @IBAction func goForward(_ sender: Any) {
        guard let totalPages = item?.timeline.count,
              currentPage + 1 < totalPages else { return }
        goto(page: currentPage + 1)
    }
    
    @IBAction func goNext(_ sender: Any) {
        PlaygroundPage.current.navigateTo(page: .next)
    }
    
    fileprivate var scriptPreamble : String {
        guard let name = item?.fileName else { return "" }
        return "var hypeDocument = HYPE.documents['\(name)']\n"
    }
    
    fileprivate func scriptCommand(for page: Int) -> String {
        guard let item = item else { return "" }
        if item.isSceneBased {
            let scene = item.timeline[page].name
            return scriptPreamble + "hypeDocument.showSceneNamed('\(scene)')"
        } else {
            let name = item.timeline[page].name
            let seconds = item.timeline[page].seconds
            return scriptPreamble + "hypeDocument.goToTimeInTimelineNamed(\(seconds), '\(name)', hypeDocument)\n" + "hypeDocument.continueTimelineNamed('\(name)', hypeDocument.kDirectionForward, false)"
        }
    }
    
    fileprivate func goto(page: Int, completion: ((Any?, Error?) -> Void)? = nil) {
        guard !webView.isHidden else { return }
        currentPage = page
        resetButtonReadyPulser(backgroundView: nextButton)
        resetButtonReadyPulser(backgroundView: startCodingButton)
        webView.evaluateJavaScript(scriptCommand(for: page)) { (foo, error) in
            self.updatePageCounter(page, of: self.item!.timeline.count)
            completion?(foo, error)
        }
    }
    
    fileprivate func updatePageCounter(_ number: Int, of total: Int) {
        pageLocation.text = String(format: NSLocalizedString("%d of %d", comment: "AX: Current cutscene page comapred to total"), number+1, total)
        updateButtonVisibility(pageNumber: number+1, total: total)
    }
    
    fileprivate func updateButtonVisibility(pageNumber: Int, total: Int) {
        guard let item = item else { return }
        let transitioningToLastPage = (pageNumber == total)
        let firstPage = (pageNumber == 1)
        
        prevButton.isEnabled = !firstPage
        nextButton.isEnabled = !transitioningToLastPage
        startCodingButton.isHidden = !transitioningToLastPage
        pageLocation.isHidden = transitioningToLastPage
        
        if let buttonView = transitioningToLastPage ? self.startCodingButton : self.nextButton {
            let pulseScale: CGFloat = transitioningToLastPage ? 1.05 : 1.15
            self.primeButtonReadyPulser(backgroundView: buttonView, pageNumber: pageNumber, pulseScale: pulseScale)
        }
        
        if transitioningToLastPage && item.isOutro {
            shadowView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: [], animations: {
            self.stackView.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func primeButtonReadyPulser(backgroundView: UIView, pageNumber: Int, pulseScale: CGFloat) {
        var seconds = 3.0 // Default
        if let item = item, (1..<item.timeline.count).contains(pageNumber) {
            let t1 = item.timeline[pageNumber - 1].seconds
            let t2 = item.timeline[pageNumber].seconds
            seconds = max(Double(t2 - t1), 0.0)
        }
        resetButtonReadyPulser(backgroundView: backgroundView)
        buttonReadyTimer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { timer in
            backgroundView.startPulsing(scale: pulseScale, repeats: 3)
        }
    }
    
    private func resetButtonReadyPulser(backgroundView: UIView) {
        backgroundView.stopPulsing()
        buttonReadyTimer?.invalidate()
        buttonReadyTimer = nil
    }
    
    private func hideControls() {
        let cssString = ".controls:not([id=\"controls-page-2a\"]) { display: none !important; }"
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(jsString, completionHandler: nil)
    }
}

extension SPCHypeCutSceneController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == "x-playgrounds" {
            let userInfo: [AnyHashable: Any] = [
                "PlaygroundPageLinkRequestPayload": url.absoluteString
            ]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "PlaygroundPageRequestsToHandleLink"), object: self, userInfo: userInfo)
        }
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideControls()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.showWebView()
        }
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.showWebView()
        }
    }
}

fileprivate extension UIView {
    func startPulsing(scale: CGFloat, repeats: Int? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration = 0.8
        animation.autoreverses = false
        animation.keyTimes = [0, 0.5, 1.0]
        animation.values = [1.0, scale, 1.0]
        animation.beginTime = 0
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = CAMediaTimingFillMode.both
        animation.repeatCount = (repeats == nil) ? .greatestFiniteMagnitude : Float(repeats ?? 0)
        layer.add(animation, forKey: "transform.scale")
    }

    func stopPulsing() {
        layer.removeAllAnimations()
    }
}
