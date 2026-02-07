//
//  LTC1_C03P01_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C03P01_Scene)
class LTC1_C03P01_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var leftHairline: UIView!
    @IBOutlet weak var leftHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftHairlineCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var rightHairline: UIView!
    @IBOutlet weak var rightHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHairlineCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var hole: HoleView!
    @IBOutlet weak var seed: SeedView!
    @IBOutlet weak var flower: FlowerView!

    private var viewsToFadeIn: [UIView] = []

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("For Loops", comment: "heading text; title of this chapter")
        secondaryTextLabel.text = NSLocalizedString("Repeating Yourself", comment: "sub heading; describes the purpose of for loops")

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

        // Prepare the animated views for their entrance animations.
        hole.shrinkToInvisible()
        seed.shrinkToInvisible()
        flower.shrinkToInvisible()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animate the hairlines down.
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
        let lineHorizontalMove: CGFloat = 38.0
        UIView.animate(withDuration: 0.5, delay: 1.45, options: [],
                       animations: {
                        self.leftHairlineCenterXConstraint.constant -= lineHorizontalMove
                        self.rightHairlineCenterXConstraint.constant += lineHorizontalMove
                        self.view.layoutIfNeeded()
        })

        hole.animateToFullSizeWithPop(duration: 0.4, delay: 1.45)
        seed.animateToFullSizeWithPop(duration: 0.4, delay: 2.2)
        seed.animateDrop(duration: 0.4, delay: 3.2)
        flower.animateToFullSizeWithBounce(duration: 0.3, delay: 3.8, then: {
            self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

}
