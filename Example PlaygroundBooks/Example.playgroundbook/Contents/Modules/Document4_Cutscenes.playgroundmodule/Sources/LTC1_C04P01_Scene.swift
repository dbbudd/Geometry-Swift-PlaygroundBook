//
//  LTC1_C04P01_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C04P01_Scene)
class LTC1_C04P01_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var hairlineLeftCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var hairlineRightCenterXConstraint: NSLayoutConstraint!

    let hairlineHorizontalMove: CGFloat = 55.0

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carImageTopConstraint: NSLayoutConstraint!

    let carVerticalMove: CGFloat = 180.0

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("Conditional Code", comment: "headline text; title of this chapter")

        secondaryTextLabel.text = NSLocalizedString("How do you plan for the unexpected?", comment: "sub-head; question")

        // The car is invisible (outside the bounds of its clipping view) when the scene starts.
        carImageTopConstraint.constant += carVerticalMove
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Do a layout pass before the layout which occurs in the animation context.
        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animate the hairlines apart and bring the car into the scene.
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [],
                       animations: {
                        self.hairlineLeftCenterXConstraint.constant -= self.hairlineHorizontalMove
                        self.hairlineRightCenterXConstraint.constant += self.hairlineHorizontalMove
                        self.carImageTopConstraint.constant -= self.carVerticalMove
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

}
