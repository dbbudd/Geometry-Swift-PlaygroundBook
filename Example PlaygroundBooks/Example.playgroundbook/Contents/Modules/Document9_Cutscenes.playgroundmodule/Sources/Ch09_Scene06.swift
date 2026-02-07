//
//  Ch09_Scene06.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch09_Scene06)
class Ch09_Scene06: SceneViewController {

    @IBOutlet weak var primaryTextLabel: SPCMultilineLabel!
    @IBOutlet weak var primaryTextLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var secondaryTextLabel: SPCMultilineLabel!
    @IBOutlet weak var houses: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("Now, let's say you want to open the garage door on a house.", comment: "primary text")

        secondaryTextLabel.text = NSLocalizedString("First you refer to that house by name, then you tell it what to do.", comment: "secondary text")

        // These elements are invisible at the start of the scene.
        houses.alpha = 0.0
        secondaryTextLabel.alpha = 0.0

        // Voiceover: Provide a description for the graphical elements.
        houses.makeAccessible(label: NSLocalizedString("Three houses, with labels: her house, my house, his house.", comment: "accessibility label"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Move in the primary text.
        animateChange(to: self.primaryTextLabelBottom, value: -246.0, duration: 0.4, delay: 0.3)

        // Fade in the rest of the scene.
        UIView.animate(withDuration: 0.3, delay: 1.0, options: [],
                       animations: {
                        self.houses.alpha = 1.0
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
