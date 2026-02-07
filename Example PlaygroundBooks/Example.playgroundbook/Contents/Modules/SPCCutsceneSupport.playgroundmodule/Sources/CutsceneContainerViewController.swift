//
//  CutsceneContainerViewController.swift
//  
//  Copyright © 2016-2020 Apple Inc. All rights reserved.
//

import UIKit

@objc(CutsceneContainerViewController)
public class CutsceneContainerViewController: UIViewController {
    
    private lazy var cutsceneViewController: StoryboardCutsceneViewController = {
        return StoryboardCutsceneViewController(storyboardName: storyboardName, storyboardIDs: storyboardIDs, displayPagingButtons: displaysPagingButtons)
    }()
    
    // If the cutscene's designs require the width to always reach the edges of the device.
    public var needsIncreasedScaling = false
    
    private let cutsceneSize = CGSize(width: 1024, height: 768)
    
    private let imageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    
    private let storyboardName: String
    private let storyboardIDs: [String]
    private let displaysPagingButtons: Bool
    private let designedRatio: CGFloat
    
    public init(storyboardName: String = "Cutscene", storyboardIDs: [String] = [], displaysPagingButtons: Bool = true, designedRatio: CGFloat = 4.0/3.0) {
        self.storyboardName = storyboardName
        self.storyboardIDs = storyboardIDs
        self.displaysPagingButtons = displaysPagingButtons
        self.designedRatio = designedRatio
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImageView()
        setupBackgroundGradientLayer()
        setupCutsceneViewController()
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let cutsceneView = cutsceneViewController.view else { return }
        
        gradientLayer.frame = view.bounds
        
        let deviceRatio = view.bounds.width / view.bounds.height
        let widthRatio = view.bounds.width / cutsceneSize.width
        let heightRatio = view.bounds.height / cutsceneSize.height
        let properRatio: CGFloat
        
        if needsIncreasedScaling {
            if deviceRatio > designedRatio {
                properRatio = widthRatio
                cutsceneViewController.makeAdjustments(cutoffPercentage: (deviceRatio / designedRatio - 1))
            } else {
                properRatio = min(widthRatio, heightRatio)
                cutsceneViewController.makeAdjustments(cutoffPercentage: 0)
            }
        } else {
            properRatio = min(widthRatio, heightRatio)
        }
    
        cutsceneView.transform = CGAffineTransform.identity.scaledBy(x: properRatio, y: properRatio)
        cutsceneView.center = view.center
    }
    
    private func setupBackgroundImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupBackgroundGradientLayer() {
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupCutsceneViewController() {
        cutsceneViewController.view.autoresizingMask = []
        addChild(cutsceneViewController)
        view.addSubview(cutsceneViewController.view)
        cutsceneViewController.view.bounds = CGRect(origin: .zero, size: cutsceneSize)
    }
    
    public func applyBackgroundImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    public func applyBackgroundGradient(topColor: UIColor, bottomColor: UIColor) {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }

}
