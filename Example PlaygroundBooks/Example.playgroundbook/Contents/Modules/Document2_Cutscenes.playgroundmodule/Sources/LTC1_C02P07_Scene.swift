//
//  LTC1_C02P07_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C02P07_Scene)
class LTC1_C02P07_Scene: SceneViewController {

    @IBOutlet weak var loopLabel: UILabel!
    @IBOutlet weak var swoopLabel: UILabel!
    @IBOutlet weak var pullLabel: UILabel!

    @IBOutlet weak var functionBeginLabel: UILabel!
    @IBOutlet weak var codeBubbleView: UIView!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutBubbleView: UIView!
    @IBOutlet weak var calloutTextPointer: UIView!

    private var topCalloutViews: [UIView] = []

    @IBOutlet weak var bottomCalloutTextLabel: UILabel!
    @IBOutlet weak var bottomCalloutBubbleView: UIView!
    @IBOutlet weak var bottomCalloutPointer: UIView!

    @IBOutlet weak var functionContentLabel: UILabel!
    @IBOutlet weak var functionContentBubble: UIView!

    private var bottomCalloutViews: [UIView] = []

    // MARK :-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        loopLabel.text = NSLocalizedString("loop", comment: "label; describes a step in the process of tying a shoelace")

        swoopLabel.text = NSLocalizedString("swoop", comment: "label; describes a step in the process of tying a shoelace")

        pullLabel.text = NSLocalizedString("pull", comment: "label; describes a step in the process of tying a shoelace")

        let functionName = "tieMyShoe"
        let accessibleFunction = NSLocalizedString("Left parenthesis. Right parenthesis. Left curly bracket.", comment: "accessibility label for the punctuation used in the definition of a function")
        functionBeginLabel.accessibilityLabel = "func \(functionName) \(accessibleFunction)"
        functionBeginLabel.text = "func \(functionName)() {"

        bottomCalloutTextLabel.text = NSLocalizedString("Give your function its behavior by adding commands inside the curly braces.", comment: "second block of callout text explaining how to define a function")

        let loopFunction = "loop"
        let swoopFunction = "swoop"
        let pullFunction = "pull"
        functionContentLabel.text = loopFunction + "()\n" + swoopFunction + "()\n" + pullFunction + "()"
        let accessibleCommands = NSLocalizedString("Left parenthesis. Right parenthesis. New line.", comment: "accessibility label for punctuation in block of code")
        functionContentLabel.accessibilityLabel = loopFunction + accessibleCommands + swoopFunction + accessibleCommands + pullFunction + accessibleCommands

        // The top callout has styled text.
        calloutTextLabel.attributedText = attributedStringForCallout()

        // The callout bubble needs a little pointer, like a popup,
        // rotate a square view 45º.
        calloutTextPointer.rotate(degrees: 45.0)
        bottomCalloutPointer.rotate(degrees: 45.0)

        topCalloutViews = [
            calloutTextLabel,
            calloutBubbleView,
            calloutTextPointer,
            codeBubbleView
        ]

        bottomCalloutViews = [
            bottomCalloutTextLabel,
            bottomCalloutBubbleView,
            bottomCalloutPointer,
            functionContentLabel,
            functionContentBubble
        ]

        // The bottom callout is invisible at the start.
        bottomCalloutViews.forEach { v in
            v.alpha = 0.0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fadeOutTopCallout(duration: 0.25, delay: 0.0)
        fadeInBottomCallout(duration: 0.75, delay: 0.25, then: {
            self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: bottomCalloutTextLabel)
    }

    // MARK :- Private

    private func fadeOutTopCallout(duration: TimeInterval, delay: TimeInterval) {

        UIView.animate(withDuration: duration, delay: delay, options: [],
                       animations: {
                        self.topCalloutViews.forEach { v in
                            v.alpha = 0.0
                        }
        })
    }

    private func fadeInBottomCallout(duration: TimeInterval, delay: TimeInterval, then completion: (() -> Void)? = nil) {

        UIView.animate(withDuration: duration, delay: delay, options: [],
                       animations: {
                        self.bottomCalloutViews.forEach { v in
                            v.alpha = 1.0
                        }
                        // Hide the original labels, so that they are not read by voiceover.
                        self.loopLabel.alpha = 0.0
                        self.swoopLabel.alpha = 0.0
                        self.pullLabel.alpha = 0.0
        },
                       completion: { _ in
                        completion?()
        })
    }

    private func attributedStringForCallout() -> NSAttributedString {
        
        let text = NSLocalizedString("To define a function, use <cv>func</cv> and choose a name. Always follow a function name with ( ).", comment: "callout text explaining how to define a function")
        
        var style = CutsceneAttributedStringStyle()
        style.fontSize = calloutTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
