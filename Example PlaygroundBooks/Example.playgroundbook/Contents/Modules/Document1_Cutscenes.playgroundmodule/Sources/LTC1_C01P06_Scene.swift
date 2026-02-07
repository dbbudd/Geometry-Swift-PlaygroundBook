//
//  LTC1_C01P06_Scene.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C01P06_Scene)
class LTC1_C01P06_Scene: SceneViewController {
    
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var primaryTextTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutTextBubble: UIView!
    
    @IBOutlet weak var calloutPointer: UIView!

    @IBOutlet weak var codeSnippetLabel: UILabel!
    @IBOutlet weak var codeSnippetBubble: UIView!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!

    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // The text shown at the top of the scene includes a bold word.
        primaryTextLabel.attributedText = attributedStringForPrimaryText()
        primaryTextLabel.alpha = 0.0

        calloutTextLabel.text = NSLocalizedString("For example, you’ll tell Byte to move forward:", comment: "callout; describes a snippet of code")

        // The callout bubble needs a little pointer, like a popup
        // so, rotate a square view 45º.
        calloutPointer.rotate(degrees: 45.0)

        // Scale Byte down to 80%.
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // Setup initial callout state.
        calloutTextLabel.alpha = 0.0
        calloutTextBubble.alpha = 0.0
        calloutPointer.alpha = 0.0
        codeSnippetBubble.alpha = 0.0

        containerView.makeAccessible(label: NSLocalizedString("Byte moves forward across the screen", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Primary text slides in from the top, with bounce.
        self.movePrimaryText(after: 0.0, then: {
            // Highlighted callout text appears and command gets highlighted.
            self.highlightCommand(after: 2.0, then: {
                // Run character walk animation.
                self.animateCharacter(then: {
                    self.animationsDidComplete()
                })
                // Trigger voiceover to begin reading.
                UIAccessibility.post(notification: .screenChanged, argument: self.primaryTextLabel)
            })
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // The animated character is embedded as a child view controller
        // using a container view in the storyboard layout.
        if let controller = segue.destination as? ByteCharacterViewController {
            animatedCharacterController = controller
        }
    }
    
    // MARK:- Private

    private var animatedCharacterController: ByteCharacterViewController?

    private func animateCharacter(then completion: (() -> Void)? = nil) {

        let duration: TimeInterval = 2.2

        // The controller has its own walk animation ...
        animatedCharacterController?.walk(for: duration)

        // But we need to move the controller across the screen ourselves.
        UIView.animate(withDuration: duration,
                       animations: {
            self.containerViewLeadingConstraint.constant = 660.0
            self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        completion?()
        })
    }
    
    private func attributedStringForPrimaryText() -> NSAttributedString {
        
        let text = NSLocalizedString("You’ll start by writing <b>commands</b> to move a character named Byte around a puzzle world, performing tasks.", comment: "primary text")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = primaryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func movePrimaryText(after delay: TimeInterval, then nextAnimation: @escaping () -> Void) {

        let targetPosition: CGFloat = primaryTextTopConstraint.constant

        // Move text offscreen after view layout has established bounds.
        primaryTextTopConstraint.constant = -primaryTextLabel.bounds.height
        self.view.layoutIfNeeded()

        // Move text onscreen.
        UIView.animate(withDuration: 0.3,
                       delay: delay,
                       options: [],
                       animations: {
                        // overshoot the target to create bounce effect
                        self.primaryTextTopConstraint.constant = targetPosition + 18.0
                        self.primaryTextLabel.alpha = 6.0
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2,
                                       animations: {
                                        self.primaryTextTopConstraint.constant = targetPosition
                                        self.primaryTextLabel.alpha = 1.0
                                        self.view.layoutIfNeeded()
                        },
                                       completion: { _ in
                                        nextAnimation()
                        })
        })
    }

    private func highlightCommand(after delay: TimeInterval, then nextAnimation: @escaping () -> Void) {

        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       options: [],
                       animations: {
                        self.calloutTextLabel.alpha = 1.0
                        self.calloutTextBubble.alpha = 1.0
                        self.calloutPointer.alpha = 1.0
                        self.codeSnippetBubble.alpha = 1.0
        },
                       completion: { _ in
                        nextAnimation()
        })
    }
}
