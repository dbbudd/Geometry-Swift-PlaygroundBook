//
//  LTC1_C03P02_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C03P02_Scene)
class LTC1_C03P02_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!

    let containerViewVerticalMove: CGFloat = 450.0

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeOut = false

        primaryTextLabel.text = NSLocalizedString("Imagine you’re helping someone plant seeds in a garden.", comment: "primary text")

        // The container view starts below the bottom of the view.
        containerViewTopConstraint.constant += containerViewVerticalMove
        view.layoutIfNeeded()

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

        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.containerViewTopConstraint.constant -= self.containerViewVerticalMove
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // The flowerbed is embedded using a container view in the storyboard,
        // capture the view controller object.
        flowerbed = segue.destination as? FlowerbedViewController
    }

    // MARK:- Private

    private var flowerbed: FlowerbedViewController?

}
