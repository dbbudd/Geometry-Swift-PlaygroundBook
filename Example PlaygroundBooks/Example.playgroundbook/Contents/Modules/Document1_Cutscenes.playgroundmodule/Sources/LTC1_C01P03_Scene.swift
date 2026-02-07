//
//  LTC1_C01P03_Scene.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C01P03_Scene)
class LTC1_C01P03_Scene: SceneViewController {
    
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var blueprintImageView: UIImageView!
    @IBOutlet weak var blueprintTopConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("Or followed instructions to assemble something cool?", comment: "primary text: a question posed to the user")

        blueprintImageView.accessibilityLabel = NSLocalizedString("set of instructions to build a drone", comment: "accessibility label")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Bring the blueprint with a bit of a bounce effect.
        UIView.animate(withDuration: 0.27,
                       animations: {
                        self.blueprintTopConstraint.constant = 0.0
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2,
                                       animations: {
                                        self.blueprintTopConstraint.constant = 18.0
                                        self.view.layoutIfNeeded()
                        },
                                       completion: { _ in
                                        self.animationsDidComplete()
                        })
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
   }
}
