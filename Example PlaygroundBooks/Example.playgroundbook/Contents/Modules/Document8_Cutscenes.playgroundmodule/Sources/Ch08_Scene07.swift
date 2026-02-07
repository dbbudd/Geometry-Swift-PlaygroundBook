//
//  Ch08_Scene07.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch08_Scene07)
class Ch08_Scene07: SceneViewController {

    @IBOutlet weak var cardTitleLabel: UILabel!

    @IBOutlet weak var primaryTextLabel: SPCMultilineLabel!

    @IBOutlet weak var declarationLabel: UILabel!

    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var assignmentHighlight: UIView!
    @IBOutlet weak var assignmentLabelLeading: NSLayoutConstraint!

    @IBOutlet weak var secondaryTextLabel: SPCMultilineLabel!

    @IBOutlet weak var calloutPointerView: SPCTriangleView!
    @IBOutlet weak var calloutBubbleView: UIView!
    @IBOutlet weak var calloutTextLabel: UILabel!

    @IBOutlet weak var initialAgeCenterY: NSLayoutConstraint!
    @IBOutlet weak var updatedAgeCenterY: NSLayoutConstraint!

    @IBOutlet weak var cardView: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldFadeIn = false

        cardTitleLabel.text = NSLocalizedString("New Contact", comment: "title of contact card")

        primaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("After you create a variable, the <b>type</b> of information it stores never changes", comment: "primary text"))

        secondaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("If you give a variable an <b>Int</b> value, you can’t later assign it a <b>String</b> value.", comment: "secondary text"))
        
        calloutTextLabel.text = NSLocalizedString("❗️ Cannot assign value of type 'String' to type 'Int'", comment: "error message in callout")

        calloutElements = [
            calloutPointerView,
            calloutBubbleView,
            calloutTextLabel,
            assignmentHighlight
        ]

        // Voiceover: Treat the contact card as a single entity.
        cardView.makeAccessible(label: NSLocalizedString("Contact card. Name: Chris, age changes from 18 to 21 after the code to the left assigns 21 as an integer", comment: "accessibility label"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade out the callout.
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [],
                       animations: {
                        self.calloutElements.forEach { $0.alpha = 0.0 }
        })

        // Move the improper assignment offscreen,
        // change the text,
        // move it back onscreen.
        UIView.animate(withDuration: 0.4, delay: 1.0, options: [],
                       animations: {
                        self.assignmentLabelTrailing =
                            self.link(self.assignmentLabel.trailingAnchor, to: self.view.leadingAnchor,
                                      removing: self.assignmentLabelLeading)
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        self.assignmentLabel.text = "age = 21"

                        UIView.animate(withDuration: 0.4, delay: 0.5, options: [],
                        animations: {
                            self.assignmentLabelLeading =
                                self.link(self.assignmentLabel.leadingAnchor, to: self.declarationLabel.leadingAnchor,
                                          removing: self.assignmentLabelTrailing)
                            self.view.layoutIfNeeded()
                        })
        })

        // Update the value for age shown in the contact card.
        UIView.animate(withDuration: 0.4, delay: 2.3, options: [],
                       animations: {
                        self.initialAgeCenterY.constant = 36.0
                        self.updatedAgeCenterY.constant = 0.0
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.cardView)
        })
    }

    // MARK:- Private

    private var calloutElements: [UIView] = []

    private var assignmentLabelTrailing: NSLayoutConstraint!
}
