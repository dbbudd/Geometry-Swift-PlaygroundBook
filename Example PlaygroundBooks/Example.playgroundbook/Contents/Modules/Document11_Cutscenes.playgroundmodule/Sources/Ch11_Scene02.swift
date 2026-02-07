//
//  Ch11_Scene02.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch11_Scene02)
class Ch11_Scene02: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var functionsLabel: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("Let’s say you’re painting the inside of your house.\n\nUsing code, you might create four different functions for the different colors you want to use.", comment: "primary text")

        // The functions are not visible at the start of the scene.
        functionsLabel.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade in the functions after a delay.
        UIView.animate(withDuration: 0.4, delay: 2.0, options: [],
                       animations: {
                        self.functionsLabel.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.primaryTextLabel)
        })
    }
}
