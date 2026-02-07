//
//  LTC1_C02P02_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C02P02_Scene)
class LTC1_C02P02_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("Every day, you perform a range of tasks automatically, without thinking about what you’re doing.", comment: "primary text")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)

        animationsDidComplete()
    }
}
