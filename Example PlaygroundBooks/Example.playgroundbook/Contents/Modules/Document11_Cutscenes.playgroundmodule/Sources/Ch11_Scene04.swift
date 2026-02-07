//
//  Ch11_Scene04.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch11_Scene04)
class Ch11_Scene04: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!

    @IBOutlet weak var paramHighlight: UIView!
    @IBOutlet weak var paramCalloutBubble: UIView!
    @IBOutlet weak var paramCalloutPointer: SPCTriangleView!
    @IBOutlet weak var paramCalloutLabel: UILabel!

    @IBOutlet weak var typeHighlight: UIView!
    @IBOutlet weak var typeCalloutBubble: UIView!
    @IBOutlet weak var typeCalloutPointer: SPCTriangleView!
    @IBOutlet weak var typeCalloutLabel: UILabel!

    @IBOutlet weak var codeLabel: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("Instead of defining different functions for each color, you could use a <b>parameter</b> to specify the color you want.", comment: "primary text"))

        typeCalloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("A parameter has a specific <b>type</b>, such as <cv>Color</cv>.", comment: "callout text; describes the type associated with a parameter in a function definition"))

        paramCalloutLabel.text = NSLocalizedString("A parameter is an input value to a function.", comment: "callout text; describes a parameter to a function")

        // Make the parameter callout pointer point down.
        paramCalloutPointer.rotate(degrees: 180)

        typeCalloutElements = [
            typeHighlight,
            typeCalloutBubble,
            typeCalloutPointer,
            typeCalloutLabel
        ]

        paramCalloutElements = [
            paramHighlight,
            paramCalloutBubble,
            paramCalloutPointer,
            paramCalloutLabel
        ]

        // The callouts are invisible at the start of the scene.
        typeCalloutElements.forEach { $0.alpha = 0.0 }
        paramCalloutElements.forEach { $0.alpha = 0.0 }

        // Voiceover: Provide a specific order to read out the content of this screen.
        view.accessibilityElements = [
            primaryTextLabel!,
            codeLabel!,
            paramCalloutLabel!,
            typeCalloutLabel!
        ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show the callouts after a delay.
        UIView.animate(withDuration: 0.4, delay: 1.5, options: [],
                       animations: {
                        self.paramCalloutElements.forEach { $0.alpha = 1.0 }
        })
        UIView.animate(withDuration: 0.4, delay: 2.5, options: [],
                       animations: {
                        self.typeCalloutElements.forEach { $0.alpha = 1.0 }
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.primaryTextLabel)
        })
    }

    // MARK:- Private

    private var typeCalloutElements: [UIView] = []
    private var paramCalloutElements: [UIView] = []
}
