//
//  Ch09_Scene05.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch09_Scene05)
class Ch09_Scene05: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    @IBOutlet weak var featuresListLabel: UILabel!
    @IBOutlet weak var behaviorsListLabel: UILabel!

    @IBOutlet weak var revealView: UIView!
    @IBOutlet weak var revealViewHeight: NSLayoutConstraint!
    @IBOutlet weak var featuresListLeading: NSLayoutConstraint!

    @IBOutlet weak var colorSwatch: UIView!

    @IBOutlet weak var propertyCalloutLabel: SPCMultilineLabel!
    @IBOutlet weak var propertyCalloutBubble: UIView!

    @IBOutlet weak var methodCalloutLabel: SPCMultilineLabel!
    @IBOutlet weak var methodCalloutBubble: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        // This scene  looks like a continuation of the previous,
        // so don't fade in, and setup the visible elements to match the previous state.

        shouldFadeIn = false

        primaryTextLabel.text = NSLocalizedString("A blueprint shows the features and behaviors of a house.", comment: "primary text")

        secondaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("In a <b>type</b>, features are called <b>properties</b>,\nand behaviors are called <b>methods</b>.", comment: "secondary text"))

        propertyCalloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("A <b>property</b> is really just a variable defined inside a type.", comment: "callout text describing a property"))

        methodCalloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("A <b>method</b> is really just a function defined inside a type.", comment: "callout text describing a method"))

        colorSwatch.layer.borderColor = UIColor.black.cgColor
        colorSwatch.layer.borderWidth = 2

        calloutElements = [
            propertyCalloutLabel,
            propertyCalloutBubble,
            methodCalloutLabel,
            methodCalloutBubble
        ]

        // These elements are invisible at the start of the scene.
        calloutElements.forEach { $0.alpha = 0.0 }
        featuresListLabel.alpha = 0.0
        behaviorsListLabel.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Change the content of the list on the left.
        var localizedHeading = NSLocalizedString("Properties", comment: "heading of a list of properties")
        var withMarkup = "<b>\(localizedHeading)</b>\n<cv>var color = </cv>\n<cv>var bedrooms = 2</cv>"
        self.featuresListLabel.setAttributedText(xmlAnnotatedString: withMarkup)
        self.featuresListLabel.textAlignment = .left

        // Voiceover: Construct special accessible label including the color literal.
        let localizedLiteral = NSLocalizedString("green", comment: "the color green")
        featuresListLabel.accessibilityLabel = "\(localizedHeading)\nvar color = \(localizedLiteral)\nvar bedrooms = 2"

        // Change the content of the list on the right.
        localizedHeading = NSLocalizedString("Methods", comment: "label on a graphic; must be very short")
        withMarkup = "<b>\(localizedHeading)</b>\n<cv>runWater()</cv>\n<cv>turnLightsOn()</cv>"
        self.behaviorsListLabel.setAttributedText(xmlAnnotatedString: withMarkup)
        self.behaviorsListLabel.textAlignment = .left

        self.view.layoutIfNeeded()

        // Show the first lines of the lists.
        UIView.animate(withDuration: 0.3, delay: 0.7, options: [],
                       animations:  {
                        self.featuresListLabel.alpha = 1.0
                        self.behaviorsListLabel.alpha = 1.0
        })

        // Show the full text of the lists.
        UIView.animate(withDuration: 0.3, delay: 1.5, options: [],
                       animations: {
                        self.view.removeConstraint(self.revealViewHeight)
                        self.revealView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                        self.view.layoutIfNeeded()
        })

        // Show the callouts.
        UIView.animate(withDuration: 0.3, delay: 2.8, options: [],
                       animations: {
                        self.calloutElements.forEach { $0.alpha = 1.0 }
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        // Since this is a continuation of the previous screen,
                        // do not repeat the primary and secondary labels.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.featuresListLabel)
        })
    }

    // MARK:- Private

    private var calloutElements: [UIView] = []
}
