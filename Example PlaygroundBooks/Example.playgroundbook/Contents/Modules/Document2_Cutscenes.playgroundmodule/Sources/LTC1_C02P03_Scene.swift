//
//  LTC1_C02P03_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C02P03_Scene)
class LTC1_C02P03_Scene: SceneViewController {

    @IBOutlet weak var firstTextLabel: UILabel!

    @IBOutlet weak var secondTextLabel: UILabel!
    @IBOutlet weak var secondTextTopConstraint: NSLayoutConstraint!

    private let secondTextYOffset: CGFloat = 100.0

    @IBOutlet weak var loopEllipseView: UIView!
    @IBOutlet weak var loopEllipseTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loopImageView: UIImageView!

    @IBOutlet weak var swoopEllipseView: UIView!
    @IBOutlet weak var swoopEllipseTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var swoopImageView: UIImageView!

    @IBOutlet weak var pullEllipseView: UIView!
    @IBOutlet weak var pullEllipseTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullImageView: UIImageView!

    private let ellipseFinalYOffset: CGFloat = 328.0

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldFadeOut = false

        firstTextLabel.text = NSLocalizedString("Even a simple task, like tying your shoe, took time to automate.", comment: "first block of text")

        secondTextLabel.text = NSLocalizedString("You learned to do it using a sequence of steps.", comment: "second block of text")

        // The second block of text starts invisible and
        // 100 pts lower that its final position.
        secondTextLabel.alpha = 0.0
        secondTextTopConstraint.constant += secondTextYOffset

        // Ellipses are invisible at the beginning of this scene.
        loopEllipseView.alpha = 0.0
        swoopEllipseView.alpha = 0.0
        pullEllipseView.alpha = 0.0

        // The shoe images on the left and right are rotated slightly.
        loopImageView.transform = loopImageView.transform.rotated(by: deg2Rad(-20))
        pullImageView.transform = pullImageView.transform.rotated(by: deg2Rad(20))

        // Ensure that the images have accessible descriptions.
        var imageNumber: Int = 0
        for image in [ loopImageView!, swoopImageView!, pullImageView! ] {
            imageNumber += 1
            let template = NSLocalizedString("Step %@ of tying shoe laces.", comment: "accessibility label; substituted word is a number")
            let ordinal = "\(imageNumber)"
            image.makeAccessible(label: String(format: template, ordinal))
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        moveTextIntoPositionWithBounce(duration: 0.75, delay: 1.0)

        makeVisibleWithPop(loopEllipseView, duration: 0.35, delay: 1.75)
        adjust(loopEllipseTopConstraint, to: ellipseFinalYOffset, duration: 3.0, delay: 2.0)

        makeVisibleWithPop(swoopEllipseView, duration: 0.35, delay: 2.25)
        adjust(swoopEllipseTopConstraint, to: ellipseFinalYOffset, duration: 2.25, delay: 2.75)

        makeVisibleWithPop(pullEllipseView, duration: 0.35, delay: 2.75)
        adjust(pullEllipseTopConstraint, to: ellipseFinalYOffset, duration: 1.5, delay: 3.5, then: {
            self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: firstTextLabel)
    }

    // MARK:- Private

    private func moveTextIntoPositionWithBounce(duration: TimeInterval, delay: TimeInterval) {

        let yBounceOffset: CGFloat = 18.0

        // The second block of text moves into position, with bounce, as it becomes visible.
        UIView.animate(withDuration: (0.667 * duration), delay: delay, options: [],
                       animations: {
                        self.secondTextLabel.alpha = 1.0
                        self.secondTextTopConstraint.constant -= self.secondTextYOffset + yBounceOffset
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        // move the text down, completing the "bounce" effect
                        UIView.animate(withDuration: (0.333 * duration)) {
                            self.secondTextTopConstraint.constant += yBounceOffset
                            self.view.layoutIfNeeded()
                        }
        })
    }

    private func makeVisibleWithPop(_ theView: UIView, duration: TimeInterval, delay: TimeInterval) {

        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.5) {
                                                        theView.alpha = 0.6
                                                        theView.transform = theView.transform.scaledBy(x: 1.1, y: 1.1)
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.25) {
                                                        theView.alpha = 0.8
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.75,
                                                       relativeDuration: 0.25) {
                                                        theView.alpha = 1.0
                                                        theView.transform = theView.transform.scaledBy(x: 0.9090, y: 0.9090)
                                    }
        })
    }

    private func adjust(_ constraint: NSLayoutConstraint, to target: CGFloat, duration: TimeInterval, delay: TimeInterval, then completion: (() -> Void)? = nil) {

        UIView.animate(withDuration: duration, delay: delay, options: [],
                       animations: {
                        constraint.constant = target
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        completion?()
        })
    }

}
