//
//  Ch09_Scene03.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch09_Scene03)
class Ch09_Scene03: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var blueHouseBottom: NSLayoutConstraint!
    @IBOutlet weak var pinkHouseBottom: NSLayoutConstraint!
    @IBOutlet weak var greenHouseBottom: NSLayoutConstraint!
    @IBOutlet weak var yellowHouseBottom: NSLayoutConstraint!

    @IBOutlet weak var blueprint: UIImageView!
    @IBOutlet weak var houses: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("When you use a blueprint to build multiple houses, you know that the houses will look similar.", comment: "primary text")

        secondaryTextLabel.setAttributedText(xmlAnnotatedString:  NSLocalizedString("In programming, a <b>type</b> is like a blueprint, and an <b>instance</b> is like a house that you built from the blueprint.", comment: "secondary text"))

        // The secondary text is inivisible at the start of the scene.
        secondaryTextLabel.alpha = 0.0

        // Voiceover: Provide descriptions for the graphical elements.
        blueprint.makeAccessible(label: NSLocalizedString("Blueprint of a house", comment: "accessibility label"))
        houses.makeAccessible(label: NSLocalizedString("Four houses of the same design, but each in a different color.", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

         // We need to have a linear animation curve, not the normal ease in ease out curve.
        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)
        let animateFrames = UIView.keyframeAnimator(totalFrames: 30)

        // Bring in each of the houses.
        UIView.animateKeyframes(withDuration: 1.0, delay: 1.2, options: [.calculationModeLinear, curveLinear],
                                animations: {
                                    animateFrames(0,9) {
                                        self.blueHouseBottom.constant = 0.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(9,18) {
                                        self.greenHouseBottom.constant = 0.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(16,25) {
                                        self.pinkHouseBottom.constant = 0.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(21,30) {
                                        self.yellowHouseBottom.constant = 0.0
                                        self.view.layoutIfNeeded()
                                    }
        })

        // Bring in the secondary text.
        UIView.animateKeyframes(withDuration: 0.3, delay: 2.8, options: [],
                                 animations: {
                                     self.secondaryTextLabel.alpha = 1.0
        },
                                 completion: { _ in
                                     self.animationsDidComplete()

                                     // Voiceover: Set the initial content.
                                     UIAccessibility.post(notification: .screenChanged,
                                                          argument: self.primaryTextLabel)
        })
    }

}
