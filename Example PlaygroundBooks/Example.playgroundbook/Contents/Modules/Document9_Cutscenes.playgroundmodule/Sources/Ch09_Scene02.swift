//
//  Ch09_Scene02.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch09_Scene02)
class Ch09_Scene02: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var blueprintView: UIImageView!
    @IBOutlet weak var blueprintViewTop: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("If you want to build a house, you use a blueprint.", comment: "primary text")

        secondaryTextLabel.text = NSLocalizedString("A blueprint shows the features of your house, such as the kitchen, bathrooms, and bedrooms.", comment: "secondary text")

        // Voiceover: Describe the image.
        blueprintView.makeAccessible(label: NSLocalizedString("Blueprint of a house", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.animateChange(to: self.blueprintViewTop, value: 204.0, duration: 0.5, delay: 0.4,
                           then: {
                            self.animationsDidComplete()

                            // Voiceover: Set the initial content.
                            UIAccessibility.post(notification: .screenChanged,
                                                 argument: self.primaryTextLabel)
        })
    }
}
