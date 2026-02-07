//
//  Ch09_Scene08.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch09_Scene08)
class Ch09_Scene08: SceneViewController {

    @IBOutlet weak var primaryTextLabel: SPCMultilineLabel!
    @IBOutlet weak var primaryTextTop: NSLayoutConstraint!

    @IBOutlet weak var codeLabel: UILabel!

    @IBOutlet weak var portalGlow: UIImageView!

    @IBOutlet weak var calloutLabel: SPCMultilineLabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: SPCTriangleView!
    @IBOutlet weak var highlightBubble: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("In the puzzle world, you can use a property to turn portals on or off.", comment: "primary text")

        calloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("Here, you’re changing the <cv>isActive</cv> property of the <cv>bluePortal</cv> instance to false, which turns the portal off.", comment: "callout text; describes an expression in code" ))

        calloutElements = [
            calloutLabel,
            calloutBubble,
            calloutPointer
        ]

        // These elements are invisible at the start of the scene.
        codeLabel.alpha = 0.0
        calloutElements.forEach { $0.alpha = 0.0 }
        highlightBubble.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Drop in the primary text.
        animateChange(to: primaryTextTop, value: 92.0, duration: 0.3, delay: 0.3)

        // Fade in the code.
        UIView.animate(withDuration: 0.4, delay: 1.3, options: [],
                       animations: {
                        self.codeLabel.alpha = 1.0
        })

        // Fade in the callout.
        UIView.animate(withDuration: 0.4, delay: 3.3, options: [],
                       animations: {
                        self.calloutElements.forEach { $0.alpha = 1.0 }
        })

        // Fade in the highlight.
        UIView.animate(withDuration: 0.4, delay: 3.7, options: [],
                       animations: {
                        self.highlightBubble.alpha = 1.0
        })

        // Deactivate the portal.
        UIView.animate(withDuration: 0.4, delay: 4.7, options: [],
                       animations: {
                        self.portalGlow.alpha = 0.0
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.primaryTextLabel)
        })
    }

    // MARK:- Private

    private var calloutElements: [UIView] = []
}
