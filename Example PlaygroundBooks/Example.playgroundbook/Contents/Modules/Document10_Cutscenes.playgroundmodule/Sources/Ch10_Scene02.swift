//
//  Ch10_Scene02.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch10_Scene02)
class Ch10_Scene02: SceneViewController {

    @IBOutlet weak var primaryTextLabel: SPCMultilineLabel!
    @IBOutlet weak var secondaryTextLabel: SPCMultilineLabel!

    @IBOutlet weak var portalContainer: UIView!
    @IBOutlet weak var characterContainer: UIView!

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var instanceLabel: UILabel!

    @IBOutlet weak var primaryTextBottom: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("Just like portals have a <b>type</b> called <cv>Portal</cv>, your character has a type called <cv>Character</cv>.", comment: "primary text"))

        secondaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("The character that you control with code is an <b>instance</b> of that type.", comment: "secondary text"))

        typeLabel.text = NSLocalizedString("Type", comment: "label on a graphic; must be very short")

        instanceLabel.text = NSLocalizedString("Instance", comment: "label in a graphic, must be very short")

        // These elements are invisible at the start of the scene.
        secondaryTextLabel.alpha = 0.0
        portalContainer.alpha = 0.0
        characterContainer.alpha = 0.0

        // Voiceover: Provide better descriptions for the graphical content.
        portalContainer.makeAccessible(label: NSLocalizedString("type: portal. instances: blue portal, green portal.", comment: "accessibility label"))
        characterContainer.makeAccessible(label: NSLocalizedString("type: character. instance: byte character.", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Drop primary text into the scene, with bounce.
        animateChange(to: primaryTextBottom, value: -240, duration: 0.5, delay: 0.3)

        // Fade in the portal related elements.
        UIView.animate(withDuration: 0.5, delay: 1.8, options: [],
                       animations: {
                        self.portalContainer.alpha = 1.0
        })

        // Fade in the character related elements.
        UIView.animate(withDuration: 0.5, delay: 2.8, options: [],
                       animations: {
                        self.characterContainer.alpha = 1.0
        })

        // Fade in the secondary text.
        UIView.animate(withDuration: 0.5, delay: 4.8, options: [],
                       animations: {
                        self.secondaryTextLabel.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.primaryTextLabel)
        })
    }

}
