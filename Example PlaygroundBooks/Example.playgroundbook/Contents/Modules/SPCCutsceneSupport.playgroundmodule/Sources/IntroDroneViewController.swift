//
//  IntroDroneViewController.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(IntroDroneViewController)
public class IntroDroneViewController: UIViewController {

    @IBOutlet weak var LR_PropView: UIImageView!
    @IBOutlet weak var RR_PropView: UIImageView!
    @IBOutlet weak var RF_PropView: UIImageView!
    @IBOutlet weak var LF_PropView: UIImageView!

    private var animationTimer: Timer?

    // MARK:- View Lifecycle

    deinit {
        animationTimer?.invalidate()
    }

    // MARK:-

    public func startAnimation(duration: TimeInterval = 1.2, completion: (() -> Void)? = nil) {

        let rearSequence = [
            UIImage(named: "prop-2")!,
            UIImage(named: "prop-1")!,
            UIImage(named: "prop-3")!
        ]

        let frontSequence = [
            UIImage(named: "prop-2")!,
            UIImage(named: "prop-1")!,
            UIImage(named: "prop-4")!,
            UIImage(named: "prop-3")!
        ]

        let spinningPropRear = UIImage.animatedImage(with: rearSequence, duration: 0.2)
        let spinningPropFront = UIImage.animatedImage(with: frontSequence, duration: 0.2667)

        LR_PropView.image = spinningPropRear
        RR_PropView.image = spinningPropRear

        LF_PropView.image = spinningPropFront
        RF_PropView.image = spinningPropFront

        animationTimer?.invalidate()

        animationTimer = Timer.scheduledTimer(withTimeInterval: duration,
                                              repeats: false) { _ in
                                                self.stopAnimation()
                                                completion?()
        }
    }

    public func stopAnimation() {

        animationTimer?.invalidate()
        animationTimer = nil

        let stillProp = UIImage(named: "prop-0")!

        [   LR_PropView,
            RR_PropView,
            RF_PropView,
            LF_PropView
        ]
        .forEach { imageView in
            imageView.image = stillProp
        }
    }
}
