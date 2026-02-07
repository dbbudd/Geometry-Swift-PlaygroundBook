//
//  Ch11_Scene08.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch11_Scene08)
class Ch11_Scene08: SceneViewController {

    @IBOutlet weak var highlightBubble: UIView!
    @IBOutlet weak var calloutLabel: UILabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: SPCTriangleView!

    @IBOutlet weak var bodyLabel: UILabel!

    @IBOutlet weak var bodyHighlightBubble: UIView!
    @IBOutlet weak var bodyCalloutBubble: UIView!
    @IBOutlet weak var bodyCalloutPointer: SPCTriangleView!
    @IBOutlet weak var bodyCalloutLabel: UILabel!

    @IBOutlet weak var car: UIImageView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        calloutLabel.setAttributedText(xmlAnnotatedString:
            NSLocalizedString("This function has a <b>parameter</b>, called <cv>count</cv>, of type <cv>Int</cv>.", comment: "callout text; describes code"))

        bodyCalloutLabel.setAttributedText(xmlAnnotatedString:
            NSLocalizedString("In the function body, the <b>parameter</b> <cv>count</cv> specifies how many times the loop will run.", comment: "callout text; describes how an argument is used within a function"))

        declCalloutElements = [
            highlightBubble,
            calloutLabel,
            calloutBubble,
            calloutPointer
        ]

        bodyCalloutElements = [
            bodyHighlightBubble,
            bodyCalloutLabel,
            bodyCalloutBubble,
            bodyCalloutPointer
        ]

        // These elements are not visible at the start of the scene.
        bodyLabel.alpha = 0.0
        bodyCalloutElements.forEach { $0.alpha = 0.0 }

        // Voiceover: Provide description of car.
        car.makeAccessible(label: NSLocalizedString("car, idling, near the bottom of the screen", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade out the callout.
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [],
                       animations: {
                        self.declCalloutElements.forEach { $0.alpha = 0.0 }
        })

        // Fade in the code block.
        UIView.animate(withDuration: 0.4, delay: 0.7, options: [],
                       animations: {
                        self.bodyLabel.alpha = 1.0
        })

        // Fade in the callout for the code block.
        UIView.animate(withDuration: 0.4, delay: 1.4, options: [],
                       animations: {
                        self.bodyCalloutElements.forEach { $0.alpha = 1.0 }
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.bodyLabel)
        })
    }

    // MARK:- Private

    private var declCalloutElements: [UIView] = []
    private var bodyCalloutElements: [UIView] = []
}
