//
//  LTC1_C01P05_Scene.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit
import os
import SPCCutsceneSupport

@objc(LTC1_C01P05_Scene)
class LTC1_C01P05_Scene: SceneViewController {
    
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var codeEditorView: UIView!

    @IBOutlet weak var lineOneView: UIView!
    @IBOutlet weak var lineTwoView: UIView!
    @IBOutlet weak var lineThreeView: UIView!
    @IBOutlet weak var lineFourView: UIView!
    @IBOutlet weak var lineFiveView: UIView!
    @IBOutlet weak var lineSixView: UIView!
    @IBOutlet weak var lineSevenView: UIView!
    @IBOutlet weak var lineEightView: UIView!

    @IBOutlet weak var lineOneWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineTwoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineThreeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineFourWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineFiveWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineSixWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineSevenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineEightWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var cursorView: UIView!
    @IBOutlet weak var cursorVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var cursorTrailingConstraint: NSLayoutConstraint!

    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        primaryTextLabel.text = NSLocalizedString("Writing code allows you to create your own set of instructions for your device to carry out.", comment: "primary text")
        secondaryTextLabel.text = NSLocalizedString("Your goal is to figure out which instructions, in which order, will result in something great.", comment: "secondary text: animates in after a delay")

        // Hide the cursor until we're ready to use it.
         cursorView.alpha = 0.0

         // hide all "lines of code"
         let widthConstraints: [NSLayoutConstraint]  = [
             lineOneWidthConstraint,
             lineTwoWidthConstraint,
             lineThreeWidthConstraint,
             lineFourWidthConstraint,
             lineFiveWidthConstraint,
             lineSixWidthConstraint,
             lineSevenWidthConstraint,
             lineEightWidthConstraint
         ]
         widthConstraints.forEach { constraint in
             constraint.constant = 0.0
         }

        codeEditorView.makeAccessible(label: NSLocalizedString("image of code in an editor window morphs into the image of a character from a game", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        moveSecondaryText(after: 1.0, then: {
            self.showCode(then: {
                self.crossfadeCodeToByte(then: {
                    self.animationsDidComplete()
                })
            })
        })

        UIAccessibility.post(notification: .screenChanged,argument: primaryTextLabel)
    }

    // MARK:- Private

    private func moveSecondaryText(after delay: TimeInterval, then nextAnimation: @escaping () -> Void) {

        UIView.animate(withDuration: 0.3,
                       delay: delay,
                       options: [],
                       animations: {
                        self.secondaryTextLeadingConstraint.constant = 53.0
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2,
                                       animations: {
                                        self.secondaryTextLeadingConstraint.constant = 68.0
                                        self.view.layoutIfNeeded()
                        },
                                       completion: { _ in
                                        nextAnimation()
                        })
        })
    }

    private func showCode(then nextAnimation: @escaping () -> Void) {

        // make cursor visible
        cursorView.alpha = 1.0

        self.expand(self.lineOneView, with: self.lineOneWidthConstraint,
                    to: 55.0, over: 0.333, then: {
            self.expand(self.lineTwoView, with: self.lineTwoWidthConstraint,
                        to: 39.0, over: 0.06, then: {
                self.expand(self.lineThreeView, with: self.lineThreeWidthConstraint,
                            to: 47.0, over: 0.3, then: {
                    self.expand(self.lineFourView, with: self.lineFourWidthConstraint,
                                to: 69.0, over: 0.333, then: {
                        self.expand(self.lineFiveView, with: self.lineFiveWidthConstraint,
                                    to: 86.0, over: 0.433, then: {
                            self.expand(self.lineSixView, with: self.lineSixWidthConstraint,
                                        to: 86.0, over: 0.467, then: {
                                self.expand(self.lineSevenView, with: self.lineSevenWidthConstraint,
                                            to: 78.0, over: 0.333, then: {
                                    self.expand(self.lineEightView, with: self.lineEightWidthConstraint,
                                                to: 55.0, over: 0.2, then: nextAnimation)
                                })
                            })
                        })
                    })
                })
            })
        })
    }

    private func expand(_ blockView: UIView, with constraint: NSLayoutConstraint, to width: CGFloat, over duration: TimeInterval, then nextAnimation: (() -> Void)? = nil) {

        attachCursor(to: blockView)

        UIView.animate(withDuration: duration,
                       animations: {
                        constraint.constant = width
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        nextAnimation?()
        })
    }

    private func attachCursor(to codeView: UIView) {

        guard let containingView = cursorView.superview
        else {
            os_log(.error, "%s:%d \n ERROR: unable to find superview for cursor", #file, #line)
            return
        }

        guard containingView == codeView.superview
        else {
            os_log(.error, "%s:%d \n ERROR: codeView and cursorView do not share a common superview", #file, #line)
            return
        }

        containingView.removeConstraints([
            cursorVerticalConstraint,
            cursorTrailingConstraint
        ])

        cursorVerticalConstraint = cursorView.centerYAnchor.constraint(equalTo: codeView.centerYAnchor)
        cursorTrailingConstraint = cursorView.trailingAnchor.constraint(equalTo: codeView.trailingAnchor)

        NSLayoutConstraint.activate([
            cursorVerticalConstraint,
            cursorTrailingConstraint
        ])

        self.view.layoutIfNeeded()
    }

    private func crossfadeCodeToByte(then completion: (() -> Void)? = nil) {

        UIView.animate(withDuration: 0.75,
                       animations: {
                        self.codeEditorView.alpha = 0.0
        },
                       completion: { _ in
                        completion?()
        })
    }
}
