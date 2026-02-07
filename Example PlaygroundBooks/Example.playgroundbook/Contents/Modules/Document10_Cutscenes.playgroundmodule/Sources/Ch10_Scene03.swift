//
//  Ch10_Scene03.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch10_Scene03)
class Ch10_Scene03: SceneViewController {

    @IBOutlet weak var primaryTextLabel: SPCMultilineLabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!

    @IBOutlet weak var expertContainerView: UIView!
    @IBOutlet weak var characterContainerView: UIView!

    @IBOutlet weak var characterMethods: UILabel!
    @IBOutlet weak var expertMethods: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("You can now control a new character <b>type</b>: <cv>Expert</cv>.\n\nThe <cv>Expert</cv> type has the same abilities as the <cv>Character</cv> type, but also has a new method, <cv>turnLockUp()</cv>.", comment: "Explanation of new Swift type; words in cv markup should be considered code"))

        typeLabel.text = NSLocalizedString("Type", comment: "label on a graphic; must be very short")

        methodLabel.text = NSLocalizedString("Methods", comment: "label on a graphic; must be very short")

        // The Expert container is not visible at the start of the scene.
        expertContainerView.alpha = 0.0

        // Voiceover: Provide better descriptions for the graphical content.
        let characterDescription = typeLabel.text! + ": Character. " + methodLabel.text! + characterMethods.text!
        let expertDescription = typeLabel.text! + ": Expert. " + methodLabel.text! + expertMethods.text!

        characterContainerView.makeAccessible(label: characterDescription)
        expertContainerView.makeAccessible(label: expertDescription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.5, delay: 3.0, options: [],
                       animations: {
                        self.expertContainerView.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.primaryTextLabel)
        })
    }
}
