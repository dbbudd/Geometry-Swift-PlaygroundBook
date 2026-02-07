//
//  Ch09_Scene07.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch09_Scene07)
class Ch09_Scene07: SceneViewController {

    @IBOutlet weak var garageDoorBottom: NSLayoutConstraint!

    @IBOutlet weak var instanceCalloutLabel: UILabel!
    @IBOutlet weak var instanceCalloutBubble: UIView!
    @IBOutlet weak var instanceCalloutPointer: SPCTriangleView!

    @IBOutlet weak var methodCalloutLabel: UILabel!
    @IBOutlet weak var methodCalloutBubble: UIView!
    @IBOutlet weak var methodCalloutPointer: SPCTriangleView!

    @IBOutlet weak var instanceHighlightBubble: UIView!
    @IBOutlet weak var methodHighlightBubble: UIView!

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var accessibleView: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        instanceCalloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("In Swift, the part before the dot is the <b>instance</b> (a specific house).", comment: "callout text describing an expression in code"))

        methodCalloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("The part after the dot is the <b>method</b> from the <cv>myHouse</cv> instance.", comment: "callout text describing an expression in code"))

        instanceCalloutElements = [
            instanceCalloutLabel,
            instanceCalloutBubble,
            instanceCalloutPointer
        ]

        methodCalloutElements = [
            methodCalloutLabel,
            methodCalloutBubble,
            methodCalloutPointer
        ]

        // These elements are invisible at the start of the scene.
        instanceCalloutElements.forEach { $0.alpha = 0.0 }
        instanceHighlightBubble.alpha = 0.0
        methodCalloutElements.forEach { $0.alpha = 0.0 }
        methodHighlightBubble.alpha = 0.0

        // Invert the instance callout pointer.
        instanceCalloutPointer.rotate(degrees: 180.0)

        // Voiceover: Provide a specific order in which to read out the elements of this page.
        view.accessibilityElements = [
            codeLabel!,
            instanceCalloutLabel!,
            methodCalloutLabel!,
            accessibleView!
        ]

        // Voiceover: Provide a description of the animation.
        accessibleView.makeAccessible(label: NSLocalizedString("Three houses. The garage door opens on the house labelled my house.", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 1.0, delay: 0.5, options: [],
                       animations: {
                        self.garageDoorBottom.constant = 50.0
                        self.view.layoutIfNeeded()
        })

        UIView.animate(withDuration: 0.4, delay: 2.5, options: [],
                       animations: {
                        self.instanceCalloutElements.forEach { $0.alpha = 1.0 }
        })

        UIView.animate(withDuration: 0.4, delay: 2.9, options: [],
                       animations: {
                        self.instanceHighlightBubble.alpha = 1.0
        })

        UIView.animate(withDuration: 0.4, delay: 4.4, options: [],
                       animations: {
                        self.methodCalloutElements.forEach { $0.alpha = 1.0 }
        })

        UIView.animate(withDuration: 0.4, delay: 4.8, options: [],
                       animations: {
                        self.methodHighlightBubble.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.codeLabel)
        })
    }

    // MARK:- Private

    private var instanceCalloutElements: [UIView] = []
    private var methodCalloutElements: [UIView] = []
}
