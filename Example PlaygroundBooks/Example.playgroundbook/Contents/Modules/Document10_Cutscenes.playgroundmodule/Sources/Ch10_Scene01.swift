//
//  Ch10_Scene01.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch10_Scene01)
class Ch10_Scene01: SceneViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var characterView: UIView!

    @IBOutlet weak var leftHairlineTop: NSLayoutConstraint!
    @IBOutlet weak var rightHairlineTop: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = NSLocalizedString("Initialization", comment: "title; the title of this chapter")
        subtitleLabel.text = NSLocalizedString("Creating the new", comment: "subtitle; describes the purpose of this chapter")

        characterView.scale(by: 0.7)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Move the hairlines into position.
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        self.leftHairlineTop.constant += self.hairlineVertical
                        self.rightHairlineTop.constant += self.hairlineVertical
                        self.view.layoutIfNeeded()
        })

        // Animate a happy little jump.
        characterController.jump(duration: 0.5, delay: 0.9)

        // Animate the character blinking its eye.
        characterController.blink(duration: 0.2, delay: 1.6, then: {
            self.animationsDidComplete()
        })

        // Voiceover: Set the initial content.
        UIAccessibility.post(notification: .screenChanged,
                             argument: self.titleLabel)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // The character controller is embedded as a child view controller
        // using a container view in the storyboard layout.
        if let controller = segue.destination as? CarmineViewController {
            characterController = controller
        }
    }

    // MARK:- Private

    private let hairlineVertical: CGFloat = 65.0
    private var characterController: CarmineViewController!
}
