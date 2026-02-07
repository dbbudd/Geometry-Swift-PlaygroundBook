//
//  LTC1_C03P04_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C03P04_Scene)
class LTC1_C03P04_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var listHeadingLabel: UILabel!
    @IBOutlet weak var listItemOneLabel: UILabel!
    @IBOutlet weak var listItemTwoLabel: UILabel!
    @IBOutlet weak var listItemThreeLabel: UILabel!

    @IBOutlet weak var instructiveTextLabel: UILabel!
    @IBOutlet weak var instructiveTextTopConstraint: NSLayoutConstraint!

    let instructiveTextVerticalMove: CGFloat = 200.0

    @IBOutlet weak var forLoopBeginLabel: UILabel!
    @IBOutlet weak var forLoopEndLabel: UILabel!

    @IBOutlet weak var containerView: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        primaryTextLabel.text = NSLocalizedString("They might say…", comment: "primary text")

        listHeadingLabel.text = NSLocalizedString("For each of these 4 seeds:", comment: "heading for a list of steps")
        listItemOneLabel.text = NSLocalizedString("make a hole", comment: "item in a list of steps")
        listItemTwoLabel.text = NSLocalizedString("place the seed", comment: "item in a list of steps")
        listItemThreeLabel.text = NSLocalizedString("move five inches forward", comment: "item in a list of steps")

        instructiveTextLabel.attributedText = attributedTextForInstructiveText()

        // The instructive text is above the visible bounds of the view at the start of the scene.
        instructiveTextTopConstraint.constant -= instructiveTextVerticalMove

        // The for loop labels are invisible at the start of the scene.
        forLoopBeginLabel.alpha = 0.0
        forLoopEndLabel.alpha = 0.0

        containerView.makeAccessible(label: NSLocalizedString("A second row of flowers has popped up in the flower garden.", comment: "accessibility label"))
        instructiveTextLabel.accessibilityLabel = NSLocalizedString("To write a for loop, use the keyword for and include the number of times the loop will run.", comment: "accessibility label")
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
        UIView.animate(withDuration: 0.3) {
            self.primaryTextLabel.alpha = 0.0
        }

        // Animate in the instructive text.
        var delay: TimeInterval = 0.3
        UIView.animate(withDuration: 0.3, delay: delay, options: [],
                       animations: {
                        self.instructiveTextTopConstraint.constant += self.instructiveTextVerticalMove
                        self.view.layoutIfNeeded()
        })

        // Animate swapping out the heading of the list with code for a for loop.
        delay += 1.5
        UIView.animate(withDuration: 1.0, delay: delay, options: [],
                       animations: {
                        self.listHeadingLabel.alpha = 0.0
                        self.forLoopBeginLabel.alpha = 1.0
                        self.forLoopEndLabel.alpha = 1.0
        })

        // Animate making a hole, planting a seed, moving to the next, 4 times.
        delay += 2.0
        let column: Int = 1
        let rows = (0...3).reversed()
        for row in rows {
            flowerbed?.hole(row: row, column: column)?.animateToFullSizeWithPop(duration: 0.4, delay: delay)
            flowerbed?.seed(row: row, column: column)?.animateToFullSizeWithPop(duration: 0.3, delay: delay + 0.4)
            flowerbed?.seed(row: row, column: column)?.animateDrop(duration: 0.3, delay: delay + 0.7)
            delay += 1.0
        }

        // Animate flowers popping up.
        delay += 0.4
        for row in rows {
            flowerbed?.flower(row: row, column: column)?.animateToFullSizeWithBounce(duration: 0.3, delay: delay)
            delay += 0.3
        }

        UIAccessibility.post(notification: .screenChanged, argument: instructiveTextLabel)

        let nsec = DispatchTime.now().uptimeNanoseconds + (9 * NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: nsec)) {
            self.animationsDidComplete()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // The flowerbed is embedded using a container view in the storyboard,
        // capture the view controller object.
        flowerbed = segue.destination as? FlowerbedViewController
    }

    // MARK:- Private

    private var flowerbed: FlowerbedViewController?

    private func attributedTextForInstructiveText() -> NSAttributedString {

        let text = NSLocalizedString("To write a <b>for loop</b>, use <cv>for</cv> and include the number of times the loop will run.", comment: "primary text explaining how to define a for loop")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = instructiveTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

}
