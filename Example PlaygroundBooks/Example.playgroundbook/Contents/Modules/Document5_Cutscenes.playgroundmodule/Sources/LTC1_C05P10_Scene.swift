//
//  LTC1_C05P10_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C05P10_Scene)
class LTC1_C05P10_Scene: SceneViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var explanatoryTextLabel: UILabel!
    @IBOutlet weak var logicalTextLabel: UILabel!

    @IBOutlet weak var commandsBlockLabel: UILabel!
    @IBOutlet weak var ifExprStartLabel: UILabel!
    @IBOutlet weak var ifExprEndLabel: UILabel!
    @IBOutlet weak var notSymbolLabel: UILabel!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: UIView!
    @IBOutlet weak var notSymbolBubble: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        titleTextLabel.text = NSLocalizedString("The Logical NOT (!) Operator", comment: "title text")
        titleTextLabel.accessibilityLabel = NSLocalizedString("The Logical NOT (exclamation mark) Operator", comment: "title text")

        explanatoryTextLabel.attributedText = attributedTextForExplanatoryText()

        logicalTextLabel.attributedText = attributedTextForLogicalText()
        logicalTextLabel.textAlignment = .left

        codeElements = [ ifExprStartLabel,
                         notSymbolLabel,
                         ifExprEndLabel,
                         commandsBlockLabel ]

        // The code elements are not visible at the start of the scene.
        for e in codeElements {
            e.alpha = 0.0
        }

        calloutTextLabel.attributedText = attributedTextForCalloutText()
        calloutPointer.rotate(degrees: 45.0)

        calloutElements = [ calloutTextLabel,
                            calloutBubble,
                            calloutPointer,
                            notSymbolBubble ]

        // The callout elements are not visible at the start of the scene.
        for e in calloutElements {
            e.alpha = 0.0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Swap out the logical text for the code text.
        UIView.animate(withDuration: 0.8, delay: 0.3, options: [],
                       animations: {
                        self.logicalTextLabel.alpha = 0.0
                        for e in self.codeElements {
                            e.alpha = 1.0
                        }
        })

        // Fade in a callout bubble to highlight the NOT symbol in the code.
        UIView.animate(withDuration: 0.5, delay: 2.0, options: [],
                       animations: {
                        for e in self.calloutElements {
                            e.alpha = 1.0
                        }
        },
                       completion: { _ in
                        UIAccessibility.post(notification: .screenChanged, argument: self.calloutTextLabel)
                        self.animationsDidComplete()
        })
    }

    // MARK:- Private

    private var calloutElements: [UIView] = []
    private var codeElements: [UIView] = []

    private func attributedTextForExplanatoryText() -> NSAttributedString {

        let text = NSLocalizedString("This operator changes a condition to its opposite. For example, if <cv>onGem</cv> is true, <cv>!onGem</cv> is false.", comment: "explanatory text; describes the effect of the logical NOT operator")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = explanatoryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func attributedTextForLogicalText() -> NSAttributedString {

        let text = NSLocalizedString("if <b>NOT</b> blocked:\n    fly away", comment: "algorithm as text")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = logicalTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func attributedTextForCalloutText() -> NSAttributedString {

        let text = NSLocalizedString("The <b>NOT</b> operator changes the condition <cv>isBlocked</cv> from false to true.", comment: "callout text; explains the effect of the logical NOT operator")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = calloutTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

}
