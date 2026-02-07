//
//  Ch08_Scene02.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch08_Scene02)
class Ch08_Scene02: SceneViewController {

    @IBOutlet weak var primaryTextLabel: SPCMultilineLabel!

    @IBOutlet weak var contactsHeader: UIView!
    @IBOutlet weak var contactsCardTitle: UILabel!

    @IBOutlet weak var contactsScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cardView: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        contactsCardTitle.text = NSLocalizedString("Contacts", comment: "title of the card showing contact names")
        
        primaryTextLabel.text = NSLocalizedString("Think about all the names and phone numbers you store in your Contacts list – far more than you can remember.", comment: "primary text")

        // Voiceover: Treat the whole contacts list as one entity.
        cardView.makeAccessible(label: NSLocalizedString("Scrolling list of contact names", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Scroll to the bottom of the contacts.
        UIView.animate(withDuration: 2.0, delay: 1.0, options: [],
                       animations: {
                        let yOffset = self.contentView.bounds.height - (self.contactsScrollView.bounds.height -
                            self.contactsHeader.bounds.height)

                        self.contactsScrollView.contentOffset = CGPoint(x: 0.0, y: yOffset)
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        // Voiceover: Set the initial content.
        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

}
