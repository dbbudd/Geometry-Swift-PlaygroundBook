//
//  LTC1_C02P01_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C02P01_Scene)
class LTC1_C02P01_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var leftHairline: UIView!
    @IBOutlet weak var leftHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftHairlineCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var rightHairline: UIView!
    @IBOutlet weak var rightHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHairlineCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewCenterYConstraint: NSLayoutConstraint!

    private var affectedByOpacityChange: [UIView] = []

    private let imageViewRotationDegrees: CGFloat = 208.0

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("Functions", comment: "heading text: title of this chapter")
        secondaryTextLabel.text = NSLocalizedString("Grouping Tasks", comment: "sub-heading text: describes the purpose of functions")

        affectedByOpacityChange = [
               leftHairline,
               rightHairline,
               primaryTextLabel,
               secondaryTextLabel
           ]

        for v in affectedByOpacityChange {
            v.alpha = 0.0
        }

        let radians = deg2Rad(imageViewRotationDegrees)
        imageView.transform = imageView.transform.rotated(by: radians)
        imageView.alpha = 0.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let lineVerticalMove: CGFloat = 64.0
        UIView.animate(withDuration: 0.5, delay: 0.45, options: [],
                       animations: {
                        for v in self.affectedByOpacityChange {
                            v.alpha = 1.0
                        }
                        self.leftHairlineTopConstraint.constant += lineVerticalMove
                        self.rightHairlineTopConstraint.constant += lineVerticalMove
                        self.view.layoutIfNeeded()
        })

        let lineHorizontalMove: CGFloat = 40.0
        UIView.animate(withDuration: 0.5, delay: 1.45, options: [],
                       animations: {
                        self.leftHairlineCenterXConstraint.constant -= lineHorizontalMove
                        self.rightHairlineCenterXConstraint.constant += lineHorizontalMove
                        self.view.layoutIfNeeded()
        })

        let imageCenterYPosition: CGFloat = 414.0
        let radians = deg2Rad(imageViewRotationDegrees)

        UIView.animate(withDuration: 0.8, delay: 1.45, options: [],
                       animations: {
                        self.imageView.transform = self.imageView.transform.rotated(by: -radians)
                        self.imageView.alpha = 1.0
                        
                        self.imageViewCenterYConstraint.constant = imageCenterYPosition
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

}
