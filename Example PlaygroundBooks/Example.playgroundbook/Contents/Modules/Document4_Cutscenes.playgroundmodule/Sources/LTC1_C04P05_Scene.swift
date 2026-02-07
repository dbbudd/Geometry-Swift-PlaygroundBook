//
//  LTC1_C04P05_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C04P05_Scene)
class LTC1_C04P05_Scene: SceneViewController {

    @IBOutlet weak var proseDescriptionLabel: UILabel!

    @IBOutlet weak var beginIfLabel: UILabel!
    @IBOutlet weak var leftCurlyBraceLabel: UILabel!
    @IBOutlet weak var rightCurlyBraceLabel: UILabel!

    @IBOutlet weak var rightCurlyBraceTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var beginIfBubble: UIView!
    @IBOutlet weak var leftCurlyBraceBubble: UIView!
    @IBOutlet weak var rightCurlyBraceBubble: UIView!

    @IBOutlet weak var ifExprCalloutLabel: UILabel!
    @IBOutlet weak var ifExprCalloutBubble: UIView!
    @IBOutlet weak var ifExprCalloutPointer: UIView!

    @IBOutlet weak var commandLabel: UILabel!
    @IBOutlet weak var commandBubble: UIView!

    @IBOutlet weak var ifBlockCalloutLabel: UILabel!
    @IBOutlet weak var ifBlockCalloutBubble: UIView!
    @IBOutlet weak var ifBlockCalloutPointer: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        // This scene is a continuation of the previous scene.
        shouldFadeIn = false

        proseDescriptionLabel.text = NSLocalizedString("Byte walks forward across the street", comment: "prose description of the action that the character will take")

        ifExprCalloutLabel.attributedText = attributedTextForIfExprCallout()
        ifExprCalloutPointer.rotate(degrees: 45.0)
        ifExprCalloutElements = [ beginIfBubble,
                                  ifExprCalloutLabel,
                                  ifExprCalloutBubble,
                                  ifExprCalloutPointer ]

        ifBlockCalloutLabel.attributedText = attributedTextForIfBlockCallout()
        ifBlockCalloutPointer.rotate(degrees: 45.0)
        ifBlockCalloutElements = [ leftCurlyBraceBubble,
                                   rightCurlyBraceBubble,
                                   commandBubble,
                                   ifBlockCalloutLabel,
                                   ifBlockCalloutBubble,
                                   ifBlockCalloutPointer ]

        // The if block callout is invisible at the start of the scene. It will fade in.
        for element in ifBlockCalloutElements {
            element.alpha = 0.0
        }

        // The command label is invisible at the start of the scene. It will fade in.
        commandLabel.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade out the callout elements.
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [],
                       animations: {
                        for element in self.ifExprCalloutElements {
                            element.alpha = 0.0
                        }
        })

        // Fade out the prose description of the action to be taken in the if block.
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [],
                       animations: {
                        self.proseDescriptionLabel.alpha = 0.0
        })

        // Fade in the command and move the closing brace up.
        UIView.animate(withDuration: 0.5, delay: 1.25, options: [],
                       animations: {
                        self.commandLabel.alpha = 1.0
                        self.attachClosingBrace(to: self.commandLabel)
                        self.view.layoutIfNeeded()
        })

        // Fade in the new callout and highlight the opening and closing braces.
        UIView.animate(withDuration: 0.5, delay: 2.25, options: [],
                       animations: {
                        for element in self.ifBlockCalloutElements {
                            element.alpha = 1.0
                        }
        },
                       completion: { _ in
                        UIAccessibility.post(notification: .screenChanged, argument: self.beginIfLabel)
                        self.animationsDidComplete()
        })
    }

    // MARK:- Private

    private var ifExprCalloutElements: [UIView] = []
    private var ifBlockCalloutElements: [UIView] = []

    private func attributedTextForIfExprCallout() -> NSAttributedString {

        let text = NSLocalizedString("To write an <b>if statement</b>, use <cv>if</cv> and add your <b>condition</b>, which can be true or false.", comment: "callout text; explaining how to write an if statement")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = ifExprCalloutLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func attributedTextForIfBlockCallout() -> NSAttributedString {

        let text = NSLocalizedString("Then add the <b>if block</b>-the commands that run if the condition is <b>true</b>.\n\nHere, <cv>lightIsGreen</cv> is true, so Byte walks forward.", comment: "callout text; explaining code in an if block")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = ifBlockCalloutLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func attachClosingBrace(to theView: UIView) {

        if let existingConstraint = rightCurlyBraceTopConstraint {
            view.removeConstraint(existingConstraint)
        }

        rightCurlyBraceTopConstraint = rightCurlyBraceLabel.topAnchor.constraint(equalTo: theView.bottomAnchor, constant: -6.0)
        rightCurlyBraceTopConstraint.isActive = true
    }
}
