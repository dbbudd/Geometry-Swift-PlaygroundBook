//
//  LTC1_C04P04_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C04P04_Scene)
class LTC1_C04P04_Scene: SceneViewController {

    @IBOutlet weak var proseDescriptionLabel: UILabel!

    @IBOutlet weak var beginIfLabel: UILabel!
    @IBOutlet weak var leftCurlyBraceLabel: UILabel!
    @IBOutlet weak var rightCurlyBraceLabel: UILabel!

    @IBOutlet weak var codeBubble: UIView!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeOut = false

        proseDescriptionLabel.text = NSLocalizedString("Byte walks forward across the street", comment: "prose description of the action that the character will take")

        calloutTextLabel.attributedText = attributedTextForCallout()
        calloutTextLabel.accessibilityLabel = NSLocalizedString("To write an if statement, use the keyword if, and add your condition, which can be true or false.", comment: "accessibility label")

        // The callout pointer needs to be rotated 45 degrees.
        calloutPointer.rotate(degrees: 45.0)

        // The callout elements are invisible at the start of the scene. They will fade in.
        calloutElements = [ codeBubble,
                            calloutTextLabel,
                            calloutBubble,
                            calloutPointer ]
        for element in calloutElements {
            element.alpha = 0.0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade in the callout elements.
        UIView.animate(withDuration: 0.5, delay: 1.5, options: [],
                       animations: {
                        for label in self.calloutElements {
                            label.alpha = 1.0
                        }
        },
                       completion: { _ in
                        UIAccessibility.post(notification: .screenChanged, argument: self.calloutTextLabel)
                        self.animationsDidComplete()
        })
    }

    // MARK:- Private

    private var codeElements: [UIView] = []
    private var calloutElements: [UIView] = []

    private func attributedTextForCallout() -> NSAttributedString {

        let text = NSLocalizedString("To write an <b>if statement</b>, use <cv>if</cv> and add your <b>condition</b>, which can be true or false.", comment: "callout text; explaining how to write an if statement")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = calloutTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
