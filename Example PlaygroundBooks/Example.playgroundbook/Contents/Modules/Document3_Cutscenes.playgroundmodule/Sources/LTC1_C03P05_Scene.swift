//
//  LTC1_C03P05_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C03P05_Scene)
class LTC1_C03P05_Scene: SceneViewController {

    @IBOutlet weak var instructiveTextLabel: UILabel!
    @IBOutlet weak var forLoopBeginLabel: UILabel!

    @IBOutlet weak var listItemOneLabel: UILabel!
    @IBOutlet weak var listItemTwoLabel: UILabel!
    @IBOutlet weak var listItemThreeLabel: UILabel!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutTextBubble: UIView!
    @IBOutlet weak var calloutBubblePointer: UIView!

    @IBOutlet weak var beginLoopBubble: UIView!
    @IBOutlet weak var endLoopBubble: UIView!

    @IBOutlet weak var commandOneLabel: UILabel!
    @IBOutlet weak var commandTwoLabel: UILabel!
    @IBOutlet weak var commandThreeLabel: UILabel!

    @IBOutlet weak var commandsLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var commandOneBubble: UIView!
    @IBOutlet weak var commandTwoBubble: UIView!
    @IBOutlet weak var commandThreeBubble: UIView!

    let commandsOffscreenOffset: CGFloat = 400.0

    @IBOutlet weak var containerView: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        instructiveTextLabel.attributedText = attributedTextForInstructiveText()

        listItemOneLabel.text = NSLocalizedString("make a hole", comment: "item in a list of steps")
        listItemTwoLabel.text = NSLocalizedString("place the seed", comment: "item in a list of steps")
        listItemThreeLabel.text = NSLocalizedString("move five inches forward", comment: "item in a list of steps")

        calloutTextLabel.text = NSLocalizedString("Add the commands to repeat within the curly braces.", comment: "callout text describing a for loop")

        // The callout bubble needs a little pointer, like a popup,
        // so rotate a square view 45º.
        calloutBubblePointer.rotate(degrees: 45.0)

        // The callout text and bubbles are invisible at the start of the scene.
        calloutElements = [ calloutTextLabel,
                            calloutTextBubble,
                            calloutBubblePointer,
                            beginLoopBubble,
                            endLoopBubble ]
        for element in calloutElements {
            element.alpha = 0.0
        }

        // The commands are invisible and are offscreen at the start of the scene.
        commandLabels = [ commandOneLabel,
                          commandTwoLabel,
                          commandThreeLabel ]
        for label in commandLabels {
            label.alpha = 0.0
        }
        commandsLeadingConstraint.constant += commandsOffscreenOffset

        // The callout bubbles for the above commands are invisible at the start of the scene.
        for bubble in [ commandOneBubble!, commandTwoBubble!, commandThreeBubble! ] {
            bubble.alpha = 0.0
        }

        // The cursor is hidden at the start of the scene.
        self.cursor.alpha = 0.0

        containerView.makeAccessible(label: NSLocalizedString("Commands are repeated until another row of flowers has been planted in the garden.", comment: "accessibility label"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // We want to show flowers (and holes) in the first and second column only.
        // Hide the others.
        let colIndex = 2
        for rowIndex in 0...3 {
            flowerbed?.hole(row: rowIndex, column: colIndex)?.shrinkToInvisible()
            flowerbed?.flower(row: rowIndex, column: colIndex)?.shrinkToInvisible()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade away the instructive text.
        UIView.animate(withDuration: 0.3) {
            self.instructiveTextLabel.alpha = 0.0
        }

        // Fade in the callout text and bubbles.
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [],
                       animations: {
                        for element in self.calloutElements {
                            element.alpha = 1.0
                        }
        })

        // Swap in lines formatted as code for the list items.
        let listItems: [UILabel] = [ listItemOneLabel, listItemTwoLabel, listItemThreeLabel ]
        UIView.animate(withDuration: 0.3, delay: 0.8, options: [],
                       animations: {
                        for label in listItems {
                            label.alpha = 0.0
                        }
        })

        // This animation is concurrent with the animation above.
        UIView.animate(withDuration: 0.5, delay: 0.8, options: [],
                       animations: {
                        for label in self.commandLabels {
                            label.alpha = 1.0
                        }
                        self.commandsLeadingConstraint.constant -= self.commandsOffscreenOffset
                        self.view.layoutIfNeeded()
        })

        // We're only operating in the far right column.
        let colIndex: Int = 2

        // Setup the rowIndex to start at the bottom.
        let numRows: Int = 4
        var rowIndex: Int = numRows - 1

        // Put the cursor at the starting position.
        if let hole = flowerbed?.hole(row: rowIndex, column: colIndex) {
            attachCursor(to: hole)
        }

        var delay: TimeInterval = 2.0

        // Animate the cursor into the scene.
        UIView.animate(withDuration: 0.5, delay: delay, options: [],
                       animations: {
                        self.cursor.alpha = 0.8
        })

        //
        // Animate the sequential highlighting of the commands in the code onscreen.
        //

        // This is the duration of one pass through highlighting the commands.
        let loopDuration: TimeInterval = 5.0

        let numCommands: Double = 3
        let totalFrames: Double = numCommands * Double(numRows)

        // We need to have a linear animation curve, not the normal ease in ease out curve.
        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)

        delay += 0.5

        UIView.animateKeyframes(withDuration: loopDuration * Double(numRows), delay: delay, options: [.calculationModeLinear, curveLinear],
                                animations: {
                                    for iteration in 0 ..< numRows {
                                        var frame = Double(iteration) * numCommands
                                        UIView.addKeyframe(withRelativeStartTime: frame / totalFrames, relativeDuration: 0.01) {
                                            self.commandThreeBubble.alpha = 0.0
                                            self.commandOneBubble.alpha = 1.0
                                        }
                                        frame += 1
                                        UIView.addKeyframe(withRelativeStartTime: frame / totalFrames, relativeDuration: 0.01) {
                                            self.commandOneBubble.alpha = 0.0
                                            self.commandTwoBubble.alpha = 1.0
                                        }
                                        frame += 1
                                        UIView.addKeyframe(withRelativeStartTime: frame / totalFrames, relativeDuration: 0.01) {
                                            self.commandTwoBubble.alpha = 0.0
                                            self.commandThreeBubble.alpha = 1.0
                                        }
                                    }
        })

        //
        // Animate the activity in the flowerbed, which is synchronized with the text highlighting above.
        //

        for _ in 0 ..< numRows {

            cursor.animateFloat(duration: loopDuration, delay: delay)

            flowerbed?.hole(row: rowIndex, column: colIndex)?.animateToFullSizeWithPop(duration: 0.4, delay: delay + 1.0)

            flowerbed?.seed(row: rowIndex, column: colIndex)?.animateToFullSizeWithPop(duration: 0.3, delay: delay + 2.5)
            flowerbed?.seed(row: rowIndex, column: colIndex)?.animateDrop(duration: 0.3, delay: delay + 2.8)

            rowIndex -= 1

            // Move the cursor to its next position.
            if let hole = flowerbed?.hole(row: rowIndex, column: colIndex) {
                UIView.animate(withDuration: 0.5, delay: delay + (loopDuration - 1.0), options: [],
                               animations: {
                                self.attachCursor(to: hole)
                })
            } else {
                // We have completed the animation loop.
                // Park the cursor outside the flowerbed, then remove the highlight from the last command.
                UIView.animate(withDuration: 0.5, delay: delay + (loopDuration - 1.0), options: [],
                               animations: {
                                self.parkCursor()
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.3) {
                                    self.commandThreeBubble.alpha = 0.0
                                }
                })
            }

            delay += loopDuration
        }

        // Animate flowers popping up, after the rest of the animations have completed.
        for rowIndex in (0 ..< numRows).reversed() {
            flowerbed?.flower(row: rowIndex, column: colIndex)?.animateToFullSizeWithBounce(duration: 0.3, delay: delay)
            delay += 0.3
        }

        UIAccessibility.post(notification: .screenChanged, argument: calloutTextLabel)

        let nsec = DispatchTime.now().uptimeNanoseconds + (22 * NSEC_PER_SEC)
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

    private var calloutElements: [UIView] = []
    private var commandLabels: [UILabel] = []

    private lazy var cursor: CursorView = {

        let cv = CursorView(frame: .zero)
        cv.translatesAutoresizingMaskIntoConstraints = false

        // These constraints do not define the size of the cursor
        // That is based on the true size of the image provided.
        // These constraints define the area in which the cursor moves,
        // relative to the hole to which it is attached.
        NSLayoutConstraint.activate([
            cv.heightAnchor.constraint(equalToConstant: 72.0),
            cv.widthAnchor.constraint(equalToConstant: 45.0)
        ])

        return cv
    }()

    private var cursorCenterXConstraint: NSLayoutConstraint?
    private var cursorBottomConstraint: NSLayoutConstraint?

    private func attributedTextForInstructiveText() -> NSAttributedString {

        let text = NSLocalizedString("To write a <b>for loop</b>, use <cv>for</cv> and include the number of times the loop will run.", comment: "primary text explaining how to define a for loop")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = instructiveTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func attachCursor(to theView: UIView) {

        if cursor.superview == nil {
            flowerbed?.view.addSubview(cursor)
        }

        for constraint in [ cursorCenterXConstraint, cursorBottomConstraint ] {
            if let exists = constraint {
                cursor.superview!.removeConstraint(exists)
            }
        }

        cursorCenterXConstraint = cursor.centerXAnchor.constraint(equalTo: theView.centerXAnchor)
        cursorBottomConstraint = cursor.bottomAnchor.constraint(equalTo: theView.bottomAnchor)

        for constraint in [ cursorCenterXConstraint, cursorBottomConstraint ] {
            constraint?.isActive = true
        }

        view.layoutIfNeeded()
    }

    private func parkCursor() {

        cursorCenterXConstraint?.constant += 56.0
        cursorBottomConstraint?.constant -= 22.0

        view.layoutIfNeeded()
    }
}
