//
//  Ch09_Scene04.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch09_Scene04)
class Ch09_Scene04: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    @IBOutlet weak var featuresListLabel: UILabel!
    @IBOutlet weak var behaviorsListLabel: UILabel!

    @IBOutlet weak var revealView: UIView!
    @IBOutlet weak var revealViewHeight: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeOut = false

        primaryTextLabel.text = NSLocalizedString("A blueprint shows the features and behaviors of a house.", comment: "primary text")

        secondaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("In a <b>type</b>, features are called <b>properties</b>,\nand behaviors are called <b>methods</b>.", comment: "secondary text"))

        featuresListLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("<b>Features</b>\nColor\nBedrooms", comment: "a list of features that a house has"))
        featuresListLabel.textAlignment = .left

        behaviorsListLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("<b>Behaviors</b>\nRun Water\nTurn on Lights", comment: "a list of things that you can do in a house"))
        behaviorsListLabel.textAlignment = .left

        // These elements are invisible at the start of the scene.
        secondaryTextLabel.alpha = 0.0
        featuresListLabel.alpha = 0.0
        behaviorsListLabel.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show the features list and the behaviors list.
        UIView.animate(withDuration: 0.3, delay: 1.0, options: [],
                       animations: {
                        self.featuresListLabel.alpha = 1.0
                        self.behaviorsListLabel.alpha = 1.0
        })

        // Reveal the list items.
        UIView.animate(withDuration: 0.3, delay: 1.6, options: [],
                       animations: {
                        self.view.removeConstraint(self.revealViewHeight)
                        self.revealView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                        self.view.layoutIfNeeded()
        })

        // Show the explanatory text.
        UIView.animate(withDuration: 0.3, delay: 3.2, options: [],
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
