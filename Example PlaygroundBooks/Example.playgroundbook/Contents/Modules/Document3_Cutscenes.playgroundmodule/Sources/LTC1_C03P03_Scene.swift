//
//  LTC1_C03P03_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C03P03_Scene)
class LTC1_C03P03_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var primaryTextTopConstraint: NSLayoutConstraint!

    let primaryTextVerticalMove: CGFloat = 120.0

    @IBOutlet weak var listHeadingLabel: UILabel!
    @IBOutlet weak var listHeadingCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var listItemOneLabel: UILabel!
    @IBOutlet weak var listItemOneLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var listItemTwoLabel: UILabel!
    @IBOutlet weak var listItemTwoLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var listItemThreeLabel: UILabel!
    @IBOutlet weak var listItemThreeLeadingConstraint: NSLayoutConstraint!

    let listItemOffscreenOffset: CGFloat = 712.0

    @IBOutlet weak var containerView: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        primaryTextLabel.text = NSLocalizedString("Imagine you’re helping someone plant seeds in a garden.", comment: "primary text")

        listHeadingLabel.text = NSLocalizedString("For each of these 4 seeds:", comment: "heading for a list of steps")
        listItemOneLabel.text = NSLocalizedString("make a hole", comment: "item in a list of steps")
        listItemTwoLabel.text = NSLocalizedString("place the seed", comment: "item in a list of steps")
        listItemThreeLabel.text = NSLocalizedString("move five inches forward", comment: "item in a list of steps")

        // The list items are invisible at the start of the scene.
        [
            listHeadingLabel,
            listItemOneLabel,
            listItemTwoLabel,
            listItemThreeLabel
        ]
        .forEach { item in
            item.alpha = 0.0
        }

        // The items in the list are initially offscreen to the right.
        [   listHeadingCenterXConstraint,
            listItemOneLeadingConstraint,
            listItemTwoLeadingConstraint,
            listItemThreeLeadingConstraint
        ]
        .forEach { constraint in
            constraint.constant += listItemOffscreenOffset
        }

        containerView.makeAccessible(label: NSLocalizedString("Flower garden with one row of flowers.", comment: "accessibility label"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // We want to show flowers (and holes) in the first column only.
        // Hide the others.
        for rowIndex in 0...3 {
            for colIndex in 1...2 {
                flowerbed?.hole(row: rowIndex, column: colIndex)?.shrinkToInvisible()
                flowerbed?.flower(row: rowIndex, column: colIndex)?.shrinkToInvisible()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade out the primary text.
        // Change the text in the primary label.
        // Fade in the new text.
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.primaryTextLabel.alpha = 0.0
        },
                       completion: { _ in
                        self.primaryTextLabel.text = NSLocalizedString("They might say…", comment: "primary text")

                        UIView.animate(withDuration: 1.0) {
                            self.primaryTextLabel.alpha = 1.0
                        }
        })

        // Move the existing text up.
        // Bring in next text from offscreen.
        let startMoveDistance = (primaryTextVerticalMove * 0.7)
        let finishMoveDistance = (primaryTextVerticalMove * 0.3)
        UIView.animate(withDuration: 0.7, delay: 2.3, options: [.curveLinear],
                       animations: {
                        self.primaryTextTopConstraint.constant -= startMoveDistance
                        self.view.layoutIfNeeded()
        },
                       completion:  { _ in
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear],
                                       animations: {
                                        self.primaryTextTopConstraint.constant -= finishMoveDistance
                                        self.listHeadingCenterXConstraint.constant = 0
                                        self.view.layoutIfNeeded()
                                        self.listHeadingLabel.alpha = 1.0
                        })
        })

        // Bring in each of the steps in the list.
        self.animateListItemOnscreen(item: self.listItemOneLabel, using: self.listItemOneLeadingConstraint, delay: 4.0, then: {
            self.animateListItemOnscreen(item: self.listItemTwoLabel, using: self.listItemTwoLeadingConstraint, then: {
                self.animateListItemOnscreen(item: self.listItemThreeLabel, using: self.listItemThreeLeadingConstraint, then: {
                    self.animationsDidComplete()

                    // Delay posting the accessibility notification until all text is onscreen.
                    UIAccessibility.post(notification: .screenChanged, argument: self.primaryTextLabel)
                })
            })
        })

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // The flowerbed is embedded using a container view in the storyboard,
        // capture the view controller object.
        flowerbed = segue.destination as? FlowerbedViewController
    }

    // MARK:- Private

    private var flowerbed: FlowerbedViewController?

    private func animateListItemOnscreen(item: UIView, using constraint: NSLayoutConstraint, duration: TimeInterval = 0.6, delay: TimeInterval = 0.0, then nextAnimation: (() -> Void)? = nil) {

        UIView.animate(withDuration: duration, delay: delay, options: [],
                       animations: {
                        constraint.constant -= self.listItemOffscreenOffset
                        self.view.layoutIfNeeded()
                        item.alpha = 1.0
        },
                       completion: { _ in
                        nextAnimation?()
        })
    }

}
