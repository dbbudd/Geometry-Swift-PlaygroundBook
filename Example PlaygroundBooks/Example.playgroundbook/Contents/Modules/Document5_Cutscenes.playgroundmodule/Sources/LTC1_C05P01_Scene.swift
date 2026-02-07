//
//  LTC1_C05P01_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C05P01_Scene)
class LTC1_C05P01_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var leftHairline: UIView!
    @IBOutlet weak var leftHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftHairlineCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var rightHairline: UIView!
    @IBOutlet weak var rightHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHairlineCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var leftAmpersandLabel: UILabel!
    @IBOutlet weak var leftAmpersandCenterYConstraint: NSLayoutConstraint!

    @IBOutlet weak var rightAmpersandLabel: UILabel!
    @IBOutlet weak var rightAmpersandCenterYConstraint: NSLayoutConstraint!

    let ampersandVerticalMove: CGFloat = 75.0

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("Logical Operators", comment: "heading text; title of this chapter")
        secondaryTextLabel.text = NSLocalizedString("Could you be more specific?", comment: "sub heading")

        // These views fade in as the page is initially presented.
        viewsToFadeIn = [
            primaryTextLabel,
            secondaryTextLabel,
            leftHairline,
            rightHairline
        ]

        for v in viewsToFadeIn {
            v.alpha = 0.0
        }

        // The ampersands are not visible at the start of the scene.
        leftAmpersandCenterYConstraint.constant += ampersandVerticalMove
        rightAmpersandCenterYConstraint.constant += ampersandVerticalMove
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


        let lineVerticalMove: CGFloat = 65.0
        UIView.animate(withDuration: 0.5, delay: 0.45, options: [],
                       animations: {
                        for v in self.viewsToFadeIn {
                            v.alpha = 1.0
                        }
                        self.leftHairlineTopConstraint.constant += lineVerticalMove
                        self.rightHairlineTopConstraint.constant += lineVerticalMove
                        self.view.layoutIfNeeded()
        })

        // Animate the hairlines apart, to make room for seed-to-flower animations.
        let lineHorizontalMove: CGFloat = 39.0
        UIView.animate(withDuration: 0.5, delay: 1.45, options: [],
                       animations: {
                        self.leftHairlineCenterXConstraint.constant -= lineHorizontalMove
                        self.rightHairlineCenterXConstraint.constant += lineHorizontalMove
                        self.view.layoutIfNeeded()
        })

        // Animate the ampersands into view.
        animateChange(to: leftAmpersandCenterYConstraint, value: 0.0, duration: 0.4, delay: 1.95)
        animateChange(to: rightAmpersandCenterYConstraint, value: 0.0, duration: 0.4, delay: 2.15, then : {
            self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }
    
    // MARK:- Private

    private var viewsToFadeIn: [UIView] = []

}
