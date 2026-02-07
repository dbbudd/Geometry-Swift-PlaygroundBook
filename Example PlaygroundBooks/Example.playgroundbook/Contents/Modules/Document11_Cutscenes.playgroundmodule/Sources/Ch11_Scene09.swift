//
//  Ch11_Scene09.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch11_Scene09)
class Ch11_Scene09: SceneViewController {

    @IBOutlet weak var bodyHighlightBubble: UIView!
    @IBOutlet weak var bodyCalloutPointer: SPCTriangleView!
    @IBOutlet weak var bodyCalloutBubble: UIView!
    @IBOutlet weak var bodyCalloutLabel: UILabel!

    @IBOutlet weak var callLabel: UILabel!

    @IBOutlet weak var callHighlightBubble: UIView!
    @IBOutlet weak var callCalloutPointer: SPCTriangleView!
    @IBOutlet weak var callCalloutBubble: UIView!
    @IBOutlet weak var callCalloutLabel: UILabel!

    @IBOutlet weak var car: UIImageView!
    @IBOutlet weak var carBottom: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        bodyCalloutLabel.setAttributedText(xmlAnnotatedString:
            NSLocalizedString("In the function body, the <b>parameter</b> <cv>count</cv> specifies how many times the loop will run.", comment: "callout text; describes how an argument is used within a function"))

        callCalloutLabel.setAttributedText(xmlAnnotatedString:
            NSLocalizedString("When you call <cv>move(count:)</cv>, you pass in an argument to specify how many times to move forward.", comment: "callout text; describes calling the function defined on this page"))

        bodyCalloutElements = [
            bodyHighlightBubble,
            bodyCalloutLabel,
            bodyCalloutBubble,
            bodyCalloutPointer
        ]

        callCalloutElements = [
            callHighlightBubble,
            callCalloutPointer,
            callCalloutBubble,
            callCalloutLabel
        ]

        // These elements are invisible at the start of the scene.
        callLabel.alpha = 0.0
        callCalloutElements.forEach { $0.alpha = 0.0 }

        // Voiceover: Provide description of car.
        car.makeAccessible(label: NSLocalizedString("the car moves forward 3 times", comment: "accessibility label"))

        // Voiceover: Specify order to read the visible elements.
        view.accessibilityElements = [
            callLabel!,
            car!,
            callCalloutLabel!
        ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade out the body callout.
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [],
                       animations: {
                        self.bodyCalloutElements.forEach { $0.alpha = 0.0 }
        })

        // Fade in the function call.
        UIView.animate(withDuration: 0.4, delay: 1.0, options: [],
                       animations: {
                        self.callLabel.alpha = 1.0
        })

        // Fade in the callout on the function call.
        UIView.animate(withDuration: 0.4, delay: 2.0, options: [],
                       animations: {
                        self.callCalloutElements.forEach { $0.alpha = 1.0 }
        },
                       completion: { _ in
                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.callLabel)
        })

        // Move the car.
        // We need to have a linear animation curve, not the normal ease in ease out curve.
        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)

        UIView.animateKeyframes(withDuration: 3.0, delay: 2.4, options: [curveLinear],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                                        self.carBottom.constant -= 180.0
                                        self.view.layoutIfNeeded()
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.25) {
                                        self.carBottom.constant -= 180.0
                                        self.view.layoutIfNeeded()
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                                        self.carBottom.constant = -20.0
                                        self.view.layoutIfNeeded()
                                    }
        },
                                completion: { _ in
                                    self.animationsDidComplete()
        })
    }

    // MARK:- Private

    private var bodyCalloutElements: [UIView] = []
    private var callCalloutElements: [UIView] = []
}
