//
//  Ch11_Scene03.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch11_Scene03)
class Ch11_Scene03: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!

    @IBOutlet weak var paintRoller: UIImageView!
    @IBOutlet weak var paintRollerBottom: NSLayoutConstraint!

    @IBOutlet weak var firstFunctionLabel: UILabel!
    @IBOutlet weak var secondFunctionLabel: UILabel!
    @IBOutlet weak var thirdFunctionLabel: UILabel!

    @IBOutlet weak var firstLayerHeight: NSLayoutConstraint!
    @IBOutlet weak var secondLayerHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdLayerHeight: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("You might need to call your function multiple times, depending on how many layers of paint are needed.", comment: "primary text")

        // The functions are not visible at the start of the scene.
        firstFunctionLabel.alpha = 0.0
        secondFunctionLabel.alpha = 0.0
        thirdFunctionLabel.alpha = 0.0

        // Voiceover: Describe paint roller animation.
        paintRoller.makeAccessible(label: NSLocalizedString("a paint roller, painting three layers of green paint", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show the first function call.
        UIView.animate(withDuration: 0.4, delay: 0.8, options: [],
                       animations: {
                        self.firstFunctionLabel.alpha = 1.0
        })

        // Move the roller up, and paint.
        UIView.animate(withDuration: 0.8, delay: 1.2, options: [],
                       animations: {
                        self.paintRollerBottom.constant += self.paintHeight - self.rollerHeight
                        self.firstLayerHeight.constant += self.paintHeight
                        self.view.layoutIfNeeded()
        })

        // Show the next function call.
        UIView.animate(withDuration: 0.4, delay: 2.0, options: [],
                       animations: {
                        self.secondFunctionLabel.alpha = 1.0
        })

        // Move the roller down, and paint.
        UIView.animate(withDuration: 0.8, delay: 2.4, options: [],
                       animations: {
                        self.paintRollerBottom.constant -= self.paintHeight - self.rollerHeight
                        self.secondLayerHeight.constant += self.paintHeight
                        self.view.layoutIfNeeded()
        })

        // Show the last function call.
        UIView.animate(withDuration: 0.4, delay: 3.2, options: [],
                       animations: {
                        self.thirdFunctionLabel.alpha = 1.0
        })

        // Move the roller up, and paint.
        UIView.animate(withDuration: 0.8, delay: 3.6, options: [],
                       animations: {
                        self.paintRollerBottom.constant += self.paintHeight - self.rollerHeight
                        self.thirdLayerHeight.constant += self.paintHeight
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.primaryTextLabel)
        })
    }

    // MARK:- Private

    private let paintHeight: CGFloat = 234.0
    private let rollerHeight: CGFloat = 48.0
}
