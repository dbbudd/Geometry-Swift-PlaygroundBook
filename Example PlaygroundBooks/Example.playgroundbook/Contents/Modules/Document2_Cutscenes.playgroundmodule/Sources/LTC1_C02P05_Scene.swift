//
//  LTC1_C02P05_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C02P05_Scene)
class LTC1_C02P05_Scene: SceneViewController {

    @IBOutlet weak var headingTextLabel: UILabel!
    @IBOutlet weak var headingTextCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var explanationTextLabel: UILabel!
    @IBOutlet weak var explanationTextTopConstraint: NSLayoutConstraint!

    private let explanationYOffset: CGFloat = 100.0

    @IBOutlet weak var loopLabel: UILabel!
    @IBOutlet weak var swoopLabel: UILabel!
    @IBOutlet weak var pullLabel: UILabel!

    @IBOutlet weak var functionBeginLabel: UILabel!
    @IBOutlet weak var functionEndLabel: UILabel!


    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        headingTextLabel.text = NSLocalizedString("To tie your shoe, you do the following:", comment: "heading to a list of items")

        loopLabel.text = NSLocalizedString("loop", comment: "label; describes a step in the process of tying a shoelace")

        swoopLabel.text = NSLocalizedString("swoop", comment: "label; describes a step in the process of tying a shoelace")

        pullLabel.text = NSLocalizedString("pull", comment: "label; describes a step in the process of tying a shoelace")

        // Because we are putting emphasis on the syntax of a function declaration, the punctuation should be read.
        let functionName = "tieMyShoe"
        let accessiblePunctuation = NSLocalizedString("Left parenthesis. Right parenthesis. Left curly bracket.", comment: "accessibility label for the punctuation used in the definition of a function")
        functionBeginLabel.accessibilityLabel = "func \(functionName) \(accessiblePunctuation)"
        functionBeginLabel.text = "func \(functionName)() {"

        // The explanation has styled text.
        explanationTextLabel.attributedText = attributedStringForExplanation()

        // The explanation starts out invisible, then drops in, with bounce.
        explanationTextTopConstraint.constant -= explanationYOffset
        explanationTextLabel.alpha = 0.0

        // The function syntax text starts out invisible.
        functionBeginLabel.alpha = 0.0
        functionEndLabel.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        moveExplanationToPositionWithBounce(duration: 0.5, delay: 0.5)
        transitionToFunctionSyntax(duration: 2.0, delay: 2.0, then: {
            self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: explanationTextLabel)
    }

    // MARK:- Private

    private func moveExplanationToPositionWithBounce(duration: TimeInterval, delay: TimeInterval) {

        let yBounceOffset: CGFloat = 18.0

        // The second block of text drops into position, with bounce, as it becomes visible.
        UIView.animate(withDuration: (0.667 * duration), delay: delay, options: [],
                       animations: {
                        self.explanationTextLabel.alpha = 1.0
                        self.explanationTextTopConstraint.constant += self.explanationYOffset + yBounceOffset
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        // Move the text down, completing the "bounce" effect.
                        UIView.animate(withDuration: (0.333 * duration)) {
                            self.explanationTextTopConstraint.constant -= yBounceOffset
                            self.view.layoutIfNeeded()
                        }
        })
    }

    private func transitionToFunctionSyntax(duration: TimeInterval, delay: TimeInterval, then completion: (() -> Void)? = nil) {

        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,
                                                       relativeDuration: 0.3) {
                                                        self.headingTextLabel.alpha = 0.0
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.3,
                                                       relativeDuration: 0.7) {
                                                        self.functionBeginLabel.alpha = 1.0
                                                        self.functionEndLabel.alpha = 1.0
                                    }

        },
                                completion: { _ in
                                    completion?()
        })
    }

    private func attributedStringForExplanation() -> NSAttributedString {
        
        let text = NSLocalizedString("In programming, a <b>function</b> allows you to name a set of commands, which you can then run any time you want.", comment: "explanatory text")
        
        var style = CutsceneAttributedStringStyle()
        style.fontSize = explanationTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
