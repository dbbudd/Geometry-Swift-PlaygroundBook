//
//  Ch10_Scene05.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch10_Scene05)
class Ch10_Scene05: SceneViewController {

    @IBOutlet weak var calloutLabel: UILabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: SPCTriangleView!
    @IBOutlet weak var codeHighlight: UIView!

    @IBOutlet weak var supplementalTextLabel: SPCMultilineLabel!
    @IBOutlet weak var supplementalTextCenterY: NSLayoutConstraint!

    @IBOutlet weak var codeLabel: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        calloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("Use dot notation to call the <b>method</b> you want to use on a specific <b>instance</b>.", comment: "callout text"))

        supplementalTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("<b>Important</b>: You must initialize <cv>expert</cv> before you can give instructions like <cv>moveForward()</cv>.", comment: "supplemental text"))

        calloutElements = [
            calloutLabel,
            calloutBubble,
            calloutPointer,
            codeHighlight
        ]

        calloutElements.forEach { $0.alpha = 0.0 }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show the callout.
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [],
                       animations: {
                        self.calloutElements.forEach { $0.alpha = 1.0 }
        })

        // Make the character do a happy little jump.
        characterController.jump(duration: 0.5, delay: 1.7)

        // Show the supplemental text.
        animateChange(to: supplementalTextCenterY, value: 0.0, duration: 0.5, delay: 2.5) {
            
            self.animationsDidComplete()

            // Voiceover: Set the initial content.
            UIAccessibility.post(notification: .screenChanged,
                                 argument: self.codeLabel)
        }

        // Make the character blink.
        characterController.blink(duration: 0.2, delay: 3.7)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // The character controller is embedded as a child view controller
        // using a container view in the storyboard layout.
        if let controller = segue.destination as? CarmineViewController {
            characterController = controller
        }
    }
    // MARK:- Private

    private var calloutElements: [UIView] = []
    private var characterController: CarmineViewController!
}
