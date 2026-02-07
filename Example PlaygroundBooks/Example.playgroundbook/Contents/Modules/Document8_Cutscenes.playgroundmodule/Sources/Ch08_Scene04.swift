//
//  Ch08_Scene04.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch08_Scene04)
class Ch08_Scene04: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!

    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardView: UIView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!

    @IBOutlet weak var varNameLabel: UILabel!
    @IBOutlet weak var varAgeLabel: UILabel!

    @IBOutlet weak var assignmentCalloutLabel: UILabel!
    @IBOutlet weak var assignmentCalloutBubble: UIView!

    @IBOutlet weak var typesCalloutLabel: UILabel!
    @IBOutlet weak var typesCalloutBubble: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        cardTitleLabel.text = NSLocalizedString("New Contact", comment: "title of contact card")
        
        primaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("To create a new variable, use <cv>var</cv> followed by a name for the new variable, then a value.", comment: "primary text"))

        varNameLabel.setAttributedText(xmlAnnotatedString: "<cv>var</cv>  name  <cv>=</cv>  \"Mia\"")

        varAgeLabel.setAttributedText(xmlAnnotatedString: "<cv>var</cv>  age  <cv>=</cv>  19")

        assignmentCalloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("The <b>assignment operator</b> (the equal sign) sets the value of the variable.", comment: "callout text"))

        typesCalloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("<cv>name</cv> stores a <b>String</b> (text in quote marks).\n<cv>age</cv> stores an <b>Int</b> (an integer, a whole number).", comment: "callout text"))

        // The variable declarations are not visible at the start of the scene.
        varNameLabel.alpha = 0.0
        varAgeLabel.alpha = 0.0

        // The callouts are not visible at the start of the scene.
        assignmentCalloutLabel.alpha = 0.0
        assignmentCalloutBubble.alpha = 0.0
        typesCalloutLabel.alpha = 0.0
        typesCalloutBubble.alpha = 0.0

        // Voiceover: Add label to the contact card.
        cardTitleLabel.accessibilityLabel = NSLocalizedString("Contact card transforms to show code", comment: "accessibility label")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade out the existing name and age.
        UIView.animate(withDuration: 0.2, delay: 1.7, options: [],
                       animations: {
                        self.nameLabel.alpha = 0.0
                        self.ageLabel.alpha = 0.0
        })

        // Grow the card to fit the new content.
        UIView.animate(withDuration: 0.3, delay: 1.9, options: [],
                       animations: {
                        NSLayoutConstraint.activate([
                            self.varNameLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20.0)
                        ])
                        self.view.layoutIfNeeded()
        })

        // Fade in the new content.
        UIView.animate(withDuration: 0.2, delay: 2.2, options: [],
                       animations: {
                        self.varNameLabel.alpha = 1.0
                        self.varAgeLabel.alpha = 1.0
        })

        // Fade in the callout for the assignment operator.
        UIView.animate(withDuration: 0.4, delay: 3.0, options: [],
                       animations: {
                        self.assignmentCalloutLabel.alpha = 1.0
                        self.assignmentCalloutBubble.alpha = 1.0
        })

        // Fade in the callout for the types.
        UIView.animate(withDuration: 0.4, delay: 4.5, options: [],
                       animations: {
                        self.typesCalloutLabel.alpha = 1.0
                        self.typesCalloutBubble.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.primaryTextLabel)
        })
    }
}
