//
//  LTC1_C05P07_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C05P07_Scene)
class LTC1_C05P07_Scene: SceneViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var explanatoryTextLabel: UILabel!
    @IBOutlet weak var logicalTextLabel: UILabel!

    @IBOutlet weak var titleTextTopConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeOut = false

        titleTextLabel.text = NSLocalizedString("The Logical OR (||) Operator", comment: "title text")

        explanatoryTextLabel.text = NSLocalizedString("This code runs if at least one condition is true.", comment: "explanatory text; describes meaning of || operator")

        logicalTextLabel.attributedText = attributedTextForLogicalText()
        logicalTextLabel.textAlignment = .left

        // Capture title text position from storyboard.
        titleTextPosition = titleTextTopConstraint.constant

        // The title and explanatory text are not visible at the start of the scene.
        titleTextTopConstraint.constant = -360.0

        // The logical text is not visible at the start of the scene.
        logicalTextLabel.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // The title and explanatory text drop in as soon as the page is visible.
        self.animateChange(to: titleTextTopConstraint, value: titleTextPosition, duration: 0.5, delay: 0.0)

        // Animate in the logical text after a brief delay.
        UIView.animate(withDuration: 0.3, delay: 0.5, options: [],
                       animations: {
                        self.logicalTextLabel.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: titleTextLabel)
    }

    // MARK:- Private

    private var titleTextPosition: CGFloat = 0.0

    private func attributedTextForLogicalText() -> NSAttributedString {

        let text = NSLocalizedString("if on a gem <b>OR</b> on a switch:\n    do a dance", comment: "algorithm as text")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = logicalTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

}
