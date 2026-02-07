//
//  Ch11_Scene07.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch11_Scene07)
class Ch11_Scene07: SceneViewController {

    @IBOutlet weak var highlightBubble: UIView!

    @IBOutlet weak var calloutLabel: UILabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: SPCTriangleView!

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var car: UIImageView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeOut = false

        calloutLabel.setAttributedText(xmlAnnotatedString:
            NSLocalizedString("This function has a <b>parameter</b>, called <cv>count</cv>, of type <cv>Int</cv>.", comment: "callout text; describes code"))

        calloutElements = [
            highlightBubble,
            calloutLabel,
            calloutBubble,
            calloutPointer
        ]

        // These elements are invisible at the start of the scene.
        calloutElements.forEach { $0.alpha = 0.0 }

        // Voiceover: Provide description of car.
        car.makeAccessible(label: NSLocalizedString("car, idling, near the bottom of the screen", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade in the callout.
        UIView.animate(withDuration: 0.4, delay: 0.8, options: [],
                       animations: {
                        self.calloutElements.forEach { $0.alpha = 1.0 }
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.codeLabel)
        })
    }

    // MARK:- Private

    private var calloutElements: [UIView] = []
}
