//
//  LTC1_C05P03_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C05P03_Scene)
class LTC1_C05P03_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var primaryTextCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var primaryTextClippingHeight: NSLayoutConstraint!

    @IBOutlet weak var equalCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var andCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var operatorTextClippingHeight: NSLayoutConstraint!

    @IBOutlet weak var additionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionClippingHeight: NSLayoutConstraint!

    @IBOutlet weak var twoLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!

    @IBOutlet weak var operatorClippingView: UIView!
    @IBOutlet weak var additionClippingView: UIView!

    // We can't measure this at run time because of scaling shenanigans.
    let halfViewWidth: CGFloat = 512.0

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.attributedText = attributedTextForPrimaryText()

        // The primary text is out of view at the start of the scene.
        primaryTextCenterYConstraint.constant += primaryTextClippingHeight.constant

        // The operators are out of view at the start of the scene.
        equalCenterYConstraint.constant += operatorTextClippingHeight.constant
        plusCenterYConstraint.constant += operatorTextClippingHeight.constant
        andCenterYConstraint.constant += operatorTextClippingHeight.constant

        // Elements of the addition operation are out of view at the start of the scene.
        additionCenterYConstraint.constant += additionClippingHeight.constant
        additionLeadingConstraint.constant += halfViewWidth
        additionTrailingConstraint.constant += halfViewWidth

        // Setup meaningful content for Voiceover.
        operatorClippingView.isAccessibilityElement = true
        operatorClippingView.accessibilityTraits = [.staticText]
        operatorClippingView.accessibilityLabel = NSLocalizedString("Symbols may include equal, plus, ampersand ampersand.", comment: "accessibility label")

        additionClippingView.isAccessibilityElement = true
        additionClippingView.accessibilityTraits = [.staticText]
        additionClippingView.accessibilityLabel = NSLocalizedString("For example, the plus symbol in the equation 2 plus 4 produces 6.", comment: "accessibility label")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animate the primary text into view.
        animateChange(to: primaryTextCenterYConstraint, value: 0, duration: 0.5, delay: 0.5)

        // Animate the operators into view.
        animateChange(to: equalCenterYConstraint, value: 0, duration: 0.3, delay: 1.3)
        animateChange(to: plusCenterYConstraint, value: 0, duration: 0.3, delay: 1.5)
        animateChange(to: andCenterYConstraint, value: 0, duration: 0.3, delay: 1.7)

        UIView.animateKeyframes(withDuration: 3.0, delay: 2.5, options: [],
                                animations: {
                                    // Animate addition elements into view.
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                                        self.additionCenterYConstraint.constant = 0.0
                                        self.additionLeadingConstraint.constant = 8.0
                                        self.additionTrailingConstraint.constant = 8.0
                                        self.view.layoutIfNeeded()
                                    }
                                    // Animate the magic of addition.
                                    UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.05) {
                                        self.additionLeadingConstraint.constant += 8.0
                                        self.additionTrailingConstraint.constant += 8.0
                                        self.view.layoutIfNeeded()
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.05) {
                                        self.additionLeadingConstraint.constant = -28.0
                                        self.additionTrailingConstraint.constant = -28.0
                                        self.view.layoutIfNeeded()
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.95, relativeDuration: 0.05) {
                                        self.addLabel.scale(by: 0.0)
                                        self.twoLabel.scale(by: 0.0)
                                        self.fourLabel.scale(by: 0.128)
                                    }
        },
                                completion: { _ in
                                    // Swap in the 6 into the existing label.
                                    self.fourLabel.text = "6"

                                    UIView.animate(withDuration: 0.1, delay: 0.0, options: [],
                                                   animations: {
                                                    self.fourLabel.scale(by: 8.0)
                                    },
                                                   completion: { _ in
                                                    self.animationsDidComplete()
                                    })
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)

    }

    // MARK:- Private

    private func attributedTextForPrimaryText() -> NSAttributedString {

        let text = NSLocalizedString("In code, an <b>operator</b> is a symbol which represents an action.", comment: "primary text")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = primaryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
