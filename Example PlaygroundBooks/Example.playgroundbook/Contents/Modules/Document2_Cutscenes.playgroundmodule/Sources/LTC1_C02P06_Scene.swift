//
//  LTC1_C02P06_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C02P06_Scene)
class LTC1_C02P06_Scene: SceneViewController {

    @IBOutlet weak var loopLabel: UILabel!
    @IBOutlet weak var swoopLabel: UILabel!
    @IBOutlet weak var pullLabel: UILabel!

    @IBOutlet weak var functionBeginLabel: UILabel!
    @IBOutlet weak var codeBubbleView: UIView!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutBubbleView: UIView!
    @IBOutlet weak var calloutTextPointer: UIView!

    private var viewsToAnimateIn: [UIView] = []

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        loopLabel.text = NSLocalizedString("loop", comment: "label; describes a step in the process of tying a shoelace")

        swoopLabel.text = NSLocalizedString("swoop", comment: "label; describes a step in the process of tying a shoelace")

        pullLabel.text = NSLocalizedString("pull", comment: "label; describes a step in the process of tying a shoelace")

        // Because we are putting emphasis on the syntax of a function declaration, the punctuation should be read.
        let functionName = "tieMyShoe"
        let accessiblePunctuation = NSLocalizedString("Left parenthesis. Right parenthesis. Left curly bracket.", comment: "accessibility label for the punctuation used in the definition of a function")
        functionBeginLabel.accessibilityLabel = "func \(functionName) \(accessiblePunctuation)"
        functionBeginLabel.text = "func \(functionName)() {"

        // The callout has styled text.
        calloutTextLabel.attributedText = attributedStringForCallout()

        // The callout bubble needs a little pointer, like a popup,
        // rotate a square view 45º.
        calloutTextPointer.rotate(degrees: 45.0)

        // Callout text and bubbles are initially not visible.
        viewsToAnimateIn = [
            calloutTextLabel,
            calloutBubbleView,
            codeBubbleView,
            calloutTextPointer
        ]

        viewsToAnimateIn.forEach { v in
            v.alpha = 0.0
        }

        calloutTextLabel.accessibilityLabel = NSLocalizedString("To define a function, use the keyword func and choose a name. Always follow a function name with parentheses.", comment: "accessibility label")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 1.0,
                       animations: {
                        self.viewsToAnimateIn.forEach { v in
                            v.alpha = 1.0
                        }
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: calloutTextLabel)
    }

    // MARK:- Private

    private func attributedStringForCallout() -> NSAttributedString {
        
        let text = NSLocalizedString("To define a function, use <cv>func</cv> and choose a name. Always follow a function name with ( ).", comment: "callout text explaining how to define a function")
        
        var style = CutsceneAttributedStringStyle()
        style.fontSize = calloutTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
