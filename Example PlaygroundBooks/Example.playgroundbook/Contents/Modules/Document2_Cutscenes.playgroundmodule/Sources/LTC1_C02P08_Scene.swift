//
//  LTC1_C02P08_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C02P08_Scene)
class LTC1_C02P08_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var primaryTextTopConstraint: NSLayoutConstraint!

    private let primaryTextYOffset: CGFloat = 190.0

    @IBOutlet weak var functionNameLabel: UILabel!
    @IBOutlet weak var functionNameBubbleView: UIView!

    @IBOutlet weak var loopEllipse: UIView!
    @IBOutlet weak var swoopEllipse: UIView!
    @IBOutlet weak var pullEllipse: UIView!

    private let ellipseOffscreenXOffset: CGFloat = 686.0

    @IBOutlet weak var loopEllipseCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var swoopEllipseCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullEllipseCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var pullImageView: UIImageView!

    // MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // This label contains styled text.
        primaryTextLabel.attributedText = attributedStringForPrimaryText()

        // The primary label is initially invisible, and lower than its final position.
        primaryTextLabel.alpha = 0.0
        primaryTextTopConstraint.constant += primaryTextYOffset

        // The ellipses all start offscreen, far to the right of their final positions.
        loopEllipseCenterXConstraint.constant = ellipseOffscreenXOffset
        swoopEllipseCenterXConstraint.constant = ellipseOffscreenXOffset
        pullEllipseCenterXConstraint.constant = ellipseOffscreenXOffset

        // The function name and its highlight bubble are initially invisible.
        functionNameLabel.alpha = 0.0
        functionNameBubbleView.alpha = 0.0

        let functionName = "tieMyShoe"
        let accessiblePunctuation = NSLocalizedString("Left parenthesis. Right parenthesis.", comment: "accessibility label for punctuation used in a function name")
        functionNameLabel.accessibilityLabel = functionName + accessiblePunctuation
        functionNameLabel.text = "\(functionName)()"

        // Ensure that the final state of the animation has a reasonable read out.
        pullImageView.makeAccessible(label: NSLocalizedString("A sneaker, with the laces tied.", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showPrimaryTextWithBounce(duration: 1.25, delay: 0.0, then: {
            self.showEllipsesWithBounce(duration: 1.0, delay: 1.0, then: {
                self.fadeInView(self.functionNameLabel, duration: 0.5, delay: 0.5)
                self.fadeInView(self.functionNameBubbleView, duration: 0.5, delay: 0.75, then: {
                    self.combineAllEllipses(duration: 0.7, delay: 0.0, then: {
                        self.animationsDidComplete()
                    })
                })
            })
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

    // MARK:- Private

    private func showPrimaryTextWithBounce(duration: TimeInterval, delay: TimeInterval, then nextAnimation: (() -> Void)?) {

        // Slide the primary text up as it becomes visible.
        let targetHeight: CGFloat = primaryTextTopConstraint.constant - primaryTextYOffset
        adjustConstraint(primaryTextTopConstraint, to: targetHeight, duration: duration, delay: delay)
        fadeInView(primaryTextLabel, duration: (0.8 * duration), delay: delay, then: nextAnimation)
    }

    private func showEllipsesWithBounce(duration: TimeInterval, delay: TimeInterval, then nextAnimation: (() -> Void)?) {

        // Bring the ellipses onscreen.
        let xOffset: CGFloat = 307.0
        adjustConstraint(loopEllipseCenterXConstraint, to: -xOffset, duration: 0.5, delay: delay + 0.0)
        adjustConstraint(swoopEllipseCenterXConstraint, to: 0.0, duration: 0.5, delay: delay + 0.25)
        adjustConstraint(pullEllipseCenterXConstraint, to: xOffset, duration: 0.5, delay: delay + 0.5, then: nextAnimation)
    }

    private func combineAllEllipses(duration: TimeInterval, delay: TimeInterval, then completion: (() -> Void)? = nil) {

        let spreadDistance: CGFloat = 47.0
        let spreadDuration: TimeInterval = 0.35 * duration
        UIView.animate(withDuration: spreadDuration,
                       delay: delay,
                       options: [.beginFromCurrentState],
                       animations: {
                        // Spread the ellipses apart.
                        self.loopEllipseCenterXConstraint.constant -= spreadDistance
                        self.pullEllipseCenterXConstraint.constant += spreadDistance
                        self.view.layoutIfNeeded()
        })

        let combineDuration: TimeInterval = 0.25 * duration
        UIView.animate(withDuration: combineDuration,
                       delay: delay + spreadDuration,
                       options: [.beginFromCurrentState],
                       animations: {
                        // Bring the ellipses to the center.
                        self.loopEllipseCenterXConstraint.constant = 0.0
                        self.pullEllipseCenterXConstraint.constant = 0.0
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        self.pullImageView.image = UIImage(named: "shoe-tied")
        })

        let expansionFactor: CGFloat = 1.3
        let expansionDuration: TimeInterval = 0.3 * duration
        UIView.animate(withDuration: expansionDuration,
                       delay: delay + spreadDuration + combineDuration,
                       options: [.beginFromCurrentState],
                       animations: {
                        // Scale the final visible ellipse up.
                        self.pullEllipse.transform = self.pullEllipse.transform.scaledBy(x: expansionFactor, y: expansionFactor)
        })

        let contractionDuration: TimeInterval = 0.1 * duration
        UIView.animate(withDuration: contractionDuration,
                       delay: delay + spreadDuration + combineDuration + expansionDuration,
                       options: [.beginFromCurrentState],
                       animations: {
                        // Scale the ellipse back to its original size.
                        self.pullEllipse.transform = self.pullEllipse.transform.scaledBy(x: 1/expansionFactor, y: 1/expansionFactor)
        },
                       completion: { _ in
                        completion?()
        })
    }

    private func adjustConstraint(_ constraint: NSLayoutConstraint, to target: CGFloat, bounce: CGFloat = 36.0, duration: TimeInterval, delay: TimeInterval, then nextAnimation: (() -> Void)? = nil) {

        UIView.animate(withDuration: (0.6667 * duration), delay: delay, options: [],
                       animations: {
                        // Overshoot the target to create a "bounce" effect.
                        constraint.constant = target - bounce
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        UIView.animate(withDuration: (0.3333 * duration),
                                       animations: {
                                        // Adjust back to the target, completing the "bounce" effect.
                                        constraint.constant = target
                                        self.view.layoutIfNeeded()
                        },
                                       completion: { _ in
                                        nextAnimation?()
                        })
        })
    }

    private func fadeInView(_ theView: UIView, duration: TimeInterval, delay: TimeInterval, then nextAnimation: (() -> Void)? = nil) {

        UIView.animate(withDuration: duration, delay: delay, options: [],
                       animations: {
                        theView.alpha = 1.0
        },
                       completion: { _ in
                        nextAnimation?()
        })
    }

    private func attributedStringForPrimaryText() -> NSAttributedString {
        
        let text = NSLocalizedString("After you <b>define</b> your function, <b>call</b> it by name to run its commands.", comment: "primary text")
        
        var style = CutsceneAttributedStringStyle()
        style.fontSize = primaryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

}
