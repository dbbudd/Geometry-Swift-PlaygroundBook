//
//  StoryboardCutsceneViewController.swift
//  
//  Copyright © 2016-2020 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

public protocol CutsceneAnimatable {
    func shouldAnimateTowards(forward: Bool) -> Bool
}

//MARK:-

@objc(StoryboardCutsceneViewController)
public class StoryboardCutsceneViewController: UIViewController {

    private var navigationButtons: SPCNavigationButtons?
    private let bottomMargin: CGFloat = -40.0

    private var storyboardName: String = ""
    private var displayPagingButtons: Bool = true
    
    var storyboardIds = [String]()
    
    var currentPageIndex = 0
    private var inTransition: Bool = false
    
    private var embeddedViewController: SceneViewController?
    
    // MARK: -
    
    public convenience init(storyboardName: String, storyboardIDs: [String], displayPagingButtons: Bool) {
        self.init(nibName: nil, bundle: nil)

        self.storyboardName = storyboardName
        self.storyboardIds = storyboardIDs
        self.displayPagingButtons = displayPagingButtons
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        if displayPagingButtons {
            setupNavigationButtons()
        }

        goToPage(at: 0)

        NotificationCenter.default.addObserver(forName: .CutsceneAnimationDidComplete, object: nil, queue: nil,
                                               using: { notification in
                                                self.pulseNextButton(notification)
        })
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateAppearance()
    }

    private func setupNavigationButtons() {

        let nav = SPCNavigationButtons(frame: CGRect(x: 0.0, y: 0.0, width: 200.0, height: 44.0))
        nav.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(nav)
        NSLayoutConstraint.activate([
            nav.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomMargin),
            nav.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        nav.nextPageButton.addTarget(self, action: #selector(didPressNextButton), for: .touchUpInside)
        nav.prevPageButton.addTarget(self, action: #selector(didPressPreviousButton), for: .touchUpInside)
        nav.nextDocButton.addTarget(self, action: #selector(didPressStartCodingButton), for: .touchUpInside)

        nav.pageCount = UInt(storyboardIds.count)

        self.navigationButtons = nav
    }

    // The colors, fonts, etc are set using this method, so that they may be easily updated
    // when the trait collection changes.
    private func updateAppearance() {

        view.backgroundColor = UIColor(named: "LTC1_Background_Blue")!
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        updateAppearance()
    }
    
    //MARK: -

    private func onTransitionCompletedToPageWith(index pageIndex: Int) {
        self.currentPageIndex = pageIndex
        self.inTransition = false
        self.navigationButtons?.currentPage = UInt(pageIndex + 1)
    }

    func goToPage(at pageIndex: Int) {
        guard pageIndex >= 0, pageIndex < storyboardIds.count, !inTransition else { return }

        inTransition = true

        navigationButtons?.nextPageButton.stopPulsing()

        // If the existing controller did not already load the page ...
        // Load up a new controller for this scene.
        let storyboardId = storyboardIds[pageIndex]
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let sceneController = storyboard.instantiateViewController(withIdentifier: storyboardId)  as! SceneViewController

        if let existingController = embeddedViewController, existingController.shouldFadeOut {
            // Animate the existing controller out.
            UIView.animate(withDuration: existingController.durationFadeOut,
                           animations:  {
                               existingController.view.alpha = 0.0
                               existingController.viewWillDisappear(true)
                           },
                           completion: { _ in
                               existingController.viewDidDisappear(true)
                               existingController.removeFromParent()
                               existingController.view.removeFromSuperview()

                            self.addSceneController(sceneController, for: pageIndex)
            })
        }
        else {
            // Immediately remove the existing child controller.
            embeddedViewController?.viewWillDisappear(false)
            embeddedViewController?.viewDidDisappear(false)
            embeddedViewController?.removeFromParent()
            embeddedViewController?.view.removeFromSuperview()

            self.addSceneController(sceneController, for: pageIndex)
        }
    }

    private func addSceneController(_ controller: SceneViewController, for pageIndex: Int) {

        self.embedChildController(controller, below: self.navigationButtons)
        self.embeddedViewController = controller

        if controller.shouldFadeIn {
            controller.view.alpha = 0.0
            UIView.animate(withDuration: controller.durationFadeIn,
                           animations: {
                               controller.view.alpha = 1.0
                           }, completion:  { _ in
                               self.onTransitionCompletedToPageWith(index: pageIndex)
                           })
        }
        else {
            // Immediately call the transition completed method.
            self.onTransitionCompletedToPageWith(index: pageIndex)
        }
    }

    // MARK:-

    @objc
    private func pulseNextButton(_ notification: Notification) {

        // Check that this is from our current content view controller.
        if let vc = notification.object as? UIViewController,
            vc == embeddedViewController {

            if currentPageIndex == (storyboardIds.count - 1) {
                // We're looking at the last page, pulse the start coding button.
                navigationButtons?.nextDocButton.startPulsing(scale: 1.05, repeats: 3)
            }
            else {
                navigationButtons?.nextPageButton.startPulsing(scale: 1.15, repeats: 3)
            }
        }
    }

    //MARK: - Actions
    
    @objc
    func didPressPreviousButton(_ sender: UIButton) {
        goToPage(at: currentPageIndex - 1)
    }
    
    @objc
    func didPressNextButton(_ sender: UIButton) {
        goToPage(at: currentPageIndex + 1)
    }
    
    @objc
    func didPressStartCodingButton(_ sender: UIButton) {
        PlaygroundPage.current.navigateTo(page: .next)
    }
    
    public func makeAdjustments(cutoffPercentage: CGFloat) {
        // Remove the implementation of this method. In practice, it causes problems.
    }

}

// MARK:-

extension Notification.Name {

    static let CutsceneAnimationDidComplete = Notification.Name(rawValue: "SwiftCutsceneAnimationDidCompleteNotification")
}

// MARK:-

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
