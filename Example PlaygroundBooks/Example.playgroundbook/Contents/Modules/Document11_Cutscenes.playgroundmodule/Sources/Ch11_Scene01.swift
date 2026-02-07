//
//  Ch11_Scene01.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch11_Scene01)
class Ch11_Scene01: SceneViewController {

    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var subtitleTextLabel: UILabel!

    @IBOutlet weak var leftHairline: UIView!
    @IBOutlet weak var leftHairlineTop: NSLayoutConstraint!
    @IBOutlet weak var rightHairline: UIView!
    @IBOutlet weak var rightHairlineTop: NSLayoutConstraint!

    @IBOutlet weak var paintRollerTop: NSLayoutConstraint!
    @IBOutlet weak var paintRollerHeight: NSLayoutConstraint!

    @IBOutlet weak var paintView: UIView!
    @IBOutlet weak var paintViewHeight: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextLabel.text = NSLocalizedString("Parameters", comment: "title text; the title of this chapter")
        subtitleTextLabel.text = NSLocalizedString("Creating options", comment: "subtitle; describes the content of this chapter")

        paintView.alpha = 0.5
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Drop the hairlines into position.
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        self.leftHairlineTop.constant += self.hairlineVertical
                        self.rightHairlineTop.constant += self.hairlineVertical
                        self.view.layoutIfNeeded()
        })

        // Move the paint roller up, with bounce.
        animateChange(to: paintRollerTop, value: 348.0, duration: 0.8, delay: 1.0)

        // Animate in paint left by the roller.
        animateChange(to: paintViewHeight, value: 122.0, duration: 0.8, delay: 1.0,
                      then: {
                        self.animationsDidComplete()
        })

        // Voiceover: Set the initial content.
        UIAccessibility.post(notification: .screenChanged,
                             argument: self.titleTextLabel)
    }

    // MARK:- Private

    private let hairlineVertical: CGFloat = 65.0

}
