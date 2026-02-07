//
//  LTC1_C02P04_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C02P04_Scene)
class LTC1_C02P04_Scene: SceneViewController {

    @IBOutlet weak var loopImageView: UIImageView!
    @IBOutlet weak var pullImageView: UIImageView!

    @IBOutlet weak var headingTextLabel: UILabel!
    @IBOutlet weak var headingTextTopConstraint: NSLayoutConstraint!

    private let headingTextYOffset: CGFloat = 80.0

    @IBOutlet weak var loopLabel: UILabel!
    @IBOutlet weak var loopLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loopLabelCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var swoopLabel: UILabel!
    @IBOutlet weak var swoopLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var swoopLabelCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var pullLabel: UILabel!
    @IBOutlet weak var pullLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullLabelCenterXConstraint: NSLayoutConstraint!

    private let labelTextYOffset: CGFloat = 180.0

    @IBOutlet weak var loopEllipseTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var swoopEllipseTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullEllipseTopConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        headingTextLabel.text = NSLocalizedString("To tie your shoe, you do the following:", comment: "heading to a list of items")

        loopLabel.text = NSLocalizedString("loop", comment: "label; describes a step in the process of tying a shoelace")

        swoopLabel.text = NSLocalizedString("swoop", comment: "label; describes a step in the process of tying a shoelace")

        pullLabel.text = NSLocalizedString("pull", comment: "label; describes a step in the process of tying a shoelace")

        // The shoe images on the left and right are rotated slightly.
        loopImageView.transform = loopImageView.transform.rotated(by: deg2Rad(-20))
        pullImageView.transform = pullImageView.transform.rotated(by: deg2Rad(20))

        // The heading text fades in and drops, with a bounce.
        // Set the initial position and visibility.
        headingTextTopConstraint.constant = 26.0
        headingTextLabel.alpha = 0.0

        // The loop, swoop, and pull labels initially appear scaled to 150%.
        let scale = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        loopLabel.transform = scale
        swoopLabel.transform = scale
        pullLabel.transform = scale

        // The loop, swoop, and pull labels appear to come from behind their images,
        // so set initial positions behind their images.
        loopLabelTopConstraint.constant += labelTextYOffset
        swoopLabelTopConstraint.constant += labelTextYOffset
        pullLabelTopConstraint.constant += labelTextYOffset
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        moveHeadingToInitialPositionWithBounce(duration: 0.5, delay: 0.0)

        revealLabel(loopLabel, using: loopLabelTopConstraint, duration: 0.3, delay: 1.0)
        revealLabel(swoopLabel, using: swoopLabelTopConstraint, duration: 0.3, delay: 2.0)
        revealLabel(pullLabel, using: pullLabelTopConstraint, duration: 0.3, delay: 3.0)

        dropEllipsesAway(duration: 0.5, delay: 4.0)

        bringVerbsTogether(duration: 0.75, delay: 4.5, then: {
            self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: headingTextLabel)
    }

    // MARK:- Private

    private func moveHeadingToInitialPositionWithBounce(duration: TimeInterval, delay: TimeInterval) {

        let yBounceOffset: CGFloat = 18.0

        // The second block of text drops into position, with bounce, as it becomes visible.
        UIView.animate(withDuration: (0.667 * duration), delay: delay, options: [],
                       animations: {
                        self.headingTextLabel.alpha = 1.0
                        self.headingTextTopConstraint.constant += self.headingTextYOffset + yBounceOffset
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        // move the text down, completing the "bounce" effect
                        UIView.animate(withDuration: (0.333 * duration)) {
                            self.headingTextTopConstraint.constant -= yBounceOffset
                            self.view.layoutIfNeeded()
                        }
        })
    }

    private func revealLabel(_ label: UILabel, using constraint: NSLayoutConstraint, duration: TimeInterval, delay: TimeInterval) {

        UIView.animate(withDuration: (0.5 * duration), delay: delay, options: [],
                       animations: {
                        label.alpha = 1.0
                        constraint.constant -= self.labelTextYOffset
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        UIView.animate(withDuration: (0.5 * duration)) {
                            label.transform = label.transform.scaledBy(x: 0.667, y: 0.667)
                        }

        })

    }

    private func dropEllipsesAway(duration: TimeInterval, delay: TimeInterval) {

        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn],
                       animations: {
                        let offscreenYOffset = self.view.bounds.size.height
                        self.loopEllipseTopConstraint.constant = offscreenYOffset
                        self.swoopEllipseTopConstraint.constant = offscreenYOffset
                        self.pullEllipseTopConstraint.constant = offscreenYOffset
                        self.view.layoutIfNeeded()
        })
    }

    private func bringVerbsTogether(duration: TimeInterval, delay: TimeInterval, then completion: (() -> Void)? = nil) {

        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn],
                       animations: {

                        self.headingTextTopConstraint.constant += 157.0

                        self.swoopLabelTopConstraint.constant += 110.0
                        self.swoopLabelCenterXConstraint.constant -= 62.0

                        self.view.removeConstraints([
                            self.loopLabelTopConstraint,
                            self.loopLabelCenterXConstraint,
                            self.pullLabelTopConstraint,
                            self.pullLabelCenterXConstraint
                        ])

                        NSLayoutConstraint.activate([
                            self.loopLabel.leadingAnchor.constraint(equalTo: self.swoopLabel.leadingAnchor),
                            self.loopLabel.bottomAnchor.constraint(equalTo: self.swoopLabel.topAnchor),
                            self.pullLabel.leadingAnchor.constraint(equalTo: self.swoopLabel.leadingAnchor),
                            self.pullLabel.topAnchor.constraint(equalTo: self.swoopLabel.bottomAnchor)
                        ])

                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        completion?()
        })
    }

}
