//
//  Ch08_Scene06.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch08_Scene06)
class Ch08_Scene06: SceneViewController {

    @IBOutlet weak var cardTitleLabel: UILabel!

    @IBOutlet weak var primaryTextLabel: SPCMultilineLabel!

    @IBOutlet weak var declarationLabel: UILabel!

    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var assignmentHighlight: UIView!
    @IBOutlet weak var assignmentLabelTrailing: NSLayoutConstraint!

    @IBOutlet weak var secondaryTextLabel: SPCMultilineLabel!

    @IBOutlet weak var calloutPointerView: SPCTriangleView!
    @IBOutlet weak var calloutBubbleView: UIView!
    @IBOutlet weak var calloutTextLabel: UILabel!

    @IBOutlet weak var cardView: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldFadeOut = false

        cardTitleLabel.text = NSLocalizedString("New Contact", comment: "title of contact card")

        primaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("After you create a variable, the <b>type</b> of information it stores never changes.", comment: "primary text"))

        secondaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("If you give a variable an <b>Int</b> value, you can’t later assign it a <b>String</b> value.", comment: "secondary text"))

        calloutTextLabel.text = NSLocalizedString("❗️ Cannot assign value of type 'String' to type 'Int'", comment: "error message in callout")

        calloutElements = [
            calloutPointerView,
            calloutBubbleView,
            calloutTextLabel,
            assignmentHighlight
        ]

        // These elements are invisible at the start of the scene.
        calloutElements.forEach { $0.alpha = 0.0 }
        secondaryTextLabel.alpha = 0.0

        // Voiceover: Treat the contact card as a single entity.
        cardView.makeAccessible(label: NSLocalizedString("contact card, name: Chris, age: 18", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show the secondary text.
        UIView.animate(withDuration: 0.3, delay: 1.2, options: [],
                       animations: {
                        self.secondaryTextLabel.alpha = 1.0
        })

        // Move in the assignment to the age variable.
        UIView.animate(withDuration: 0.4, delay: 2.5, options: [],
                       animations: {
                        _ = self.link(self.assignmentLabel.leadingAnchor, to: self.declarationLabel.leadingAnchor,
                                      removing: self.assignmentLabelTrailing)
                        self.view.layoutIfNeeded()
        })

        // Show assignment callout.
        UIView.animate(withDuration: 0.3, delay: 3.0, options: [],
                       animations: {
                        self.calloutElements.forEach { $0.alpha = 1.0 }
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.primaryTextLabel)
        })

    }

    // MARK:-  Private

    private var calloutElements: [UIView] = []
}
