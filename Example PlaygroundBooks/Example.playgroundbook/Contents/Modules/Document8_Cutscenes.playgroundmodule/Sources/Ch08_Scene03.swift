//
//  Ch08_Scene03.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch08_Scene03)
class Ch08_Scene03: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var cardTitleLabel: UILabel!

    @IBOutlet weak var cardView: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        cardTitleLabel.text = NSLocalizedString("New Contact", comment: "title of contact card")

        primaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("Coders store information using named containers called <b>variables</b>.", comment: "primary text"))

        secondaryTextLabel.text = NSLocalizedString("Like a contact in your list, a variable doesn’t change its information unless you change it yourself.", comment: "secondary text")

        // The secondary text fades in after the start of the scene.
        secondaryTextLabel.alpha = 0.0

        // Voiceover: Treat the whole contacts list as one entity.
        cardView.makeAccessible(label: NSLocalizedString("New contact details, name: Mia, age: 19", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade in the secondary text.
        UIView.animate(withDuration: 0.4, delay: 0.75, options: [],
                       animations: {
                        self.secondaryTextLabel.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        // Voiceover: Set the initial content.
        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }
}
