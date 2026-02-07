//
//  LTC1_C01P02_Scene.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C01P02_Scene)
class LTC1_C01P02_Scene: SceneViewController {
    
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()
    
        primaryTextLabel.text = NSLocalizedString("Have you ever followed a recipe to bake something delicious?", comment: "primary text: a question posed to the user")

        imageView.accessibilityLabel = NSLocalizedString("slice of cake", comment: "accessibility label")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)

        animationsDidComplete()
    }
}
