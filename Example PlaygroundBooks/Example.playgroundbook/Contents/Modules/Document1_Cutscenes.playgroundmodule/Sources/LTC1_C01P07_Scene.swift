//
//  LTC1_C01P07_Scene.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C01P07_Scene)
class LTC1_C01P07_Scene: SceneViewController {
    
    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutTextBubble: UIView!
    @IBOutlet weak var calloutTextPointer: UIView!
    
    @IBOutlet weak var codeSnippetLabel: UILabel!
    @IBOutlet weak var codeSnippetBubble: UIView!
    
    @IBOutlet weak var gemImageView: UIImageView!
    @IBOutlet weak var gemFlashImageView: UIImageView!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!

    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calloutTextLabel.text = NSLocalizedString("Or collect a gem:", comment: "callout; describes a snippet of code")
        
        // The callout bubble needs a little pointer, like a popup
        // so, rotate a square view 45º.
        calloutTextPointer.transform = CGAffineTransform.init(rotationAngle: 0.25 * CGFloat.pi)

        // Scale Byte down to 80%.
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        // Setup initial state.
        calloutTextLabel.alpha = 0.0
        calloutTextBubble.alpha = 0.0
        calloutTextPointer.alpha = 0.0
        codeSnippetBubble.alpha = 0.0

        containerView.makeAccessible(label: NSLocalizedString("Byte jumps and collects a gem", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Activate the character's jump animation, after a delay.
        self.animatedCharacterController?.jump(for: 1.0, after: 1.8)

        // Get keyframe animation helper.
        let animateFrames = UIView.keyframeAnimator(totalFrames: 90)

        // Setup animations.
        UIView.animateKeyframes(withDuration: 3.0,
                                delay: 0.5,
                                options: [.beginFromCurrentState],
                                animations: {
                                    animateFrames(0, 15) {
                                        self.brightenGem()
                                    }
                                    animateFrames(15, 30) {
                                        self.returnGemToNormal()
                                        self.showCallout()
                                    }
                                    animateFrames(30, 45) {
                                        self.brightenGem()
                                        // character winks
                                    }
                                    animateFrames(45, 60) {
                                        self.returnGemToNormal()
                                    }
                                    // frame 45
                                    // character jump animation activates
                                    animateFrames(54, 65) {
                                        self.moveCharacterUp()
                                    }
                                    animateFrames(60, 75) {
                                        self.activateGem()
                                    }
                                    animateFrames(65, 70) {
                                        self.moveCharacterDown()
                                    }
                                    // frame 75
                                    // character jump animation finishes
                                    animateFrames(75, 90) {
                                        self.fadeGemAway()
                                    }
        },
                                completion: { _ in
                                    self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: calloutTextLabel)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let controller = segue.destination as? ByteCharacterViewController {
            animatedCharacterController = controller
        }
    }

    // MARK:- Private

    private let characterJumpHeight: CGFloat = 120.0

    private var animatedCharacterController: ByteCharacterViewController?

    private func showCallout() {

        self.calloutTextLabel.alpha = 1.0
        self.calloutTextBubble.alpha = 1.0
        self.calloutTextPointer.alpha = 1.0
        self.codeSnippetBubble.alpha = 1.0
    }

    private func brightenGem() {

        self.gemImageView.alpha = 0.88
    }

    private func returnGemToNormal() {

        self.gemImageView.alpha = 1.0
    }

    private func activateGem() {

        self.gemImageView.alpha = 0.0
    }

    private func fadeGemAway() {

        self.gemFlashImageView.alpha = 0.0
    }

    private func moveCharacterUp() {

        self.containerViewBottomConstraint.constant += characterJumpHeight
        self.view.layoutIfNeeded()
    }

    private func moveCharacterDown() {

        self.containerViewBottomConstraint.constant -= characterJumpHeight
        self.view.layoutIfNeeded()
    }
}
