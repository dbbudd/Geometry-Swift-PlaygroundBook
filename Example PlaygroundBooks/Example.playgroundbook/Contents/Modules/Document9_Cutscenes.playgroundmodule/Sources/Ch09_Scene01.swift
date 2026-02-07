//
//  Ch09_Scene01.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch09_Scene01)
class Ch09_Scene01: SceneViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var garageDoorBottom: NSLayoutConstraint!

    @IBOutlet weak var compositeView: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = NSLocalizedString("Types", comment: "title text; the title of this chapter")

        subtitleLabel.text = NSLocalizedString("Smart blueprints", comment: "subtitle; descriptive text supporting the title")

        compositeView.scale(by: 0.62)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 1.0, delay: 0.5, options: [],
                       animations: {
                        self.garageDoorBottom.constant = 50.0
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        // Voiceover: Set the initial content.
        UIAccessibility.post(notification: .screenChanged,
                             argument: self.titleLabel)
    }

}
