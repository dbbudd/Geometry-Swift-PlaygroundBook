//
//  Ch08_Scene05.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch08_Scene05)
class Ch08_Scene05: SceneViewController {

    @IBOutlet weak var primaryTextLabel: SPCMultilineLabel!

    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!

    @IBOutlet weak var firstAgeLabel: UILabel!
    @IBOutlet weak var firstAgeLabelCenterY: NSLayoutConstraint!

    @IBOutlet weak var secondAgeLabel: UILabel!
    @IBOutlet weak var secondAgeLabelCenterY: NSLayoutConstraint!

    @IBOutlet weak var thirdAgeLabel: UILabel!
    @IBOutlet weak var thirdAgeLabelCenterY: NSLayoutConstraint!

    @IBOutlet weak var fourthAgeLabel: UILabel!
    @IBOutlet weak var fourthAgeLabelCenterY: NSLayoutConstraint!

    @IBOutlet weak var firstAssignmentLabel: UILabel!

    @IBOutlet weak var secondAssignmentLabel: UILabel!
    @IBOutlet weak var secondAssignmentTrailing: NSLayoutConstraint!

    @IBOutlet weak var thirdAssignmentLabel: UILabel!
    @IBOutlet weak var thirdAssignmentTrailing: NSLayoutConstraint!

    @IBOutlet weak var fourthAssignmentLabel: UILabel!
    @IBOutlet weak var fourthAssignmentTrailing: NSLayoutConstraint!

    @IBOutlet weak var calloutTextLabel: SPCMultilineLabel!
    @IBOutlet weak var calloutBubble: UIView!

    @IBOutlet weak var cardView: UIView!

    //MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        cardTitleLabel.text = NSLocalizedString("New Contact", comment: "title of contact card")

        primaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("With the <b>assignment operator</b>, you can set a new value for a variable.", comment: "primary text"))

        calloutTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("Use <b>arithmetic operators</b> ( + - * / ) to add, subtract, multiply, or divide an <b>Int</b>.", comment: "callout text"))

        // The callout is invisible at the start of the scene.
        calloutTextLabel.alpha = 0.0
        calloutBubble.alpha = 0.0

        // Voiceover: Treat the contact card as a single entity.
        cardView.makeAccessible(label: NSLocalizedString("Contact card. Name: Chris. The age shown changes as the code to the left is executed.", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Move in the second assignment to the age variable.
        UIView.animate(withDuration: 0.4, delay: 1.2, options: [],
                       animations: {
                        _ = self.link(self.secondAssignmentLabel.leadingAnchor, to: self.firstAssignmentLabel.leadingAnchor,
                                      removing: self.secondAssignmentTrailing)
                        self.view.layoutIfNeeded()
        })

        // Fade in the arithmetic operators callout.
        UIView.animate(withDuration: 0.4, delay: 3.8, options: [],
                       animations: {
                        self.calloutTextLabel.alpha = 1.0
                        self.calloutBubble.alpha = 1.0
        })

        // Move in the third assignment to the age variable.
        UIView.animate(withDuration: 0.4, delay: 4.8, options: [],
                       animations: {
                        _ = self.link(self.thirdAssignmentLabel.leadingAnchor, to: self.firstAssignmentLabel.leadingAnchor,
                                      removing: self.thirdAssignmentTrailing)
                        self.view.layoutIfNeeded()
        })

        // Move in the fourth assignment to the age variable.
        UIView.animate(withDuration: 0.4, delay: 7.7, options: [],
                       animations: {
                        _ = self.link(self.fourthAssignmentLabel.leadingAnchor, to: self.firstAssignmentLabel.leadingAnchor,
                                      removing: self.fourthAssignmentTrailing)
                        self.view.layoutIfNeeded()
        })

        // We need to have a linear animation curve, not the normal ease in ease out curve.
        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)
        let animateFrames = UIView.keyframeAnimator(totalFrames: 291)

        // Animate changes to the age field on the contact card.
        UIView.animateKeyframes(withDuration: 9.7, delay: 0.0, options: [.calculationModeLinear, curveLinear],
                                animations: {
                                    animateFrames(48,54) {
                                        self.firstAgeLabelCenterY.constant = 36.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(54,60) {
                                        self.secondAgeLabelCenterY.constant = 0.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(159,165) {
                                        self.secondAgeLabelCenterY.constant = 36.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(165,171) {
                                        self.thirdAgeLabelCenterY.constant = 0.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(247,253) {
                                        self.thirdAgeLabelCenterY.constant = 36.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(253,259) {
                                        self.fourthAgeLabelCenterY.constant = 0.0
                                        self.view.layoutIfNeeded()
                                    }
        },
                                completion: { _ in
                                    self.animationsDidComplete()

                                    // Voiceover: Set the initial content.
                                    UIAccessibility.post(notification: .screenChanged,
                                                         argument: self.primaryTextLabel)
        })
    }
}
