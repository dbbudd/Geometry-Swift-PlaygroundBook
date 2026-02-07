//
//  LTC1_C05P08_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C05P08_Scene)
class LTC1_C05P08_Scene: SceneViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var explanatoryTextLabel: UILabel!
    @IBOutlet weak var logicalTextLabel: UILabel!

    @IBOutlet weak var commandsBlockLabel: UILabel!
    @IBOutlet weak var ifExprStartLabel: UILabel!
    @IBOutlet weak var ifExprEndLabel: UILabel!
    @IBOutlet weak var orSymbolLabel: UILabel!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: UIView!
    @IBOutlet weak var orSymbolBubble: UIView!

    @IBOutlet weak var secondaryCalloutLabel: UILabel!
    @IBOutlet weak var secondaryCalloutBubble: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false

        titleTextLabel.text = NSLocalizedString("The Logical OR (||) Operator", comment: "title text")

        explanatoryTextLabel.text = NSLocalizedString("This code runs if at least one condition is true.", comment: "explanatory text; describes meaning of || operator")

        logicalTextLabel.attributedText = attributedTextForLogicalText()
        logicalTextLabel.textAlignment = .left

        codeElements = [ ifExprStartLabel,
                         orSymbolLabel,
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
                            orSymbolBubble ]

        // The callout elements are not visible at the start of the scene.
        for e in calloutElements {
            e.alpha = 0.0
        }

        secondaryCalloutLabel.text = NSLocalizedString("Byte also dances if both conditions are true.", comment: "callout text; further explanation of the logical OR operator")

        secondaryCalloutElements = [ secondaryCalloutLabel,
                                     secondaryCalloutBubble ]

        // The secondary callout fades in at the end of the scene.
        for e in secondaryCalloutElements {
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

        // Fade in a callout bubble to highlight the OR symbol in the code.
        UIView.animate(withDuration: 0.5, delay: 2.0, options: [],
                       animations: {
                        for e in self.calloutElements {
                            e.alpha = 1.0
                        }
        },
                       completion: { _ in
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.calloutTextLabel)
        })

        // Fade in the clarification callout.
        UIView.animate(withDuration: 0.5, delay: 3.0, options: [],
                       animations: {
                        for e in self.secondaryCalloutElements {
                            e.alpha = 1.0
                        }
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })
    }

    // MARK:- Private

    private var codeElements: [UIView] = []
    private var calloutElements: [UIView] = []
    private var secondaryCalloutElements: [UIView] = []

    private let onSwitchVariable = "isOnSwitch"
    private let onGemVariable = "isOnGem"

    private func attributedTextForLogicalText() -> NSAttributedString {

        let text = NSLocalizedString("if on a gem <b>OR</b> on a switch:\n    do a dance", comment: "algorithm as text")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = logicalTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func attributedTextForCalloutText() -> NSAttributedString {

        let template = NSLocalizedString("Either <cv>%@</cv> <b>OR</b> <cv>%@</cv> must be true for Byte to dance.", comment: "callout text explaining how OR operator affects an if statement; the inserted items are variable names")
        let text = String(format: template, arguments: [onGemVariable, onSwitchVariable])

        var style = CutsceneAttributedStringStyle()
        style.fontSize = calloutTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
