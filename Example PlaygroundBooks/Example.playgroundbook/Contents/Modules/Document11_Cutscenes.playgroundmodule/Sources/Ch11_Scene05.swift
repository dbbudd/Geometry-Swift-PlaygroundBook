//
//  Ch11_Scene05.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch11_Scene05)
class Ch11_Scene05: SceneViewController {

    @IBOutlet weak var calloutLabel: UILabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: SPCTriangleView!
    @IBOutlet weak var highlightBubble: UIView!

    @IBOutlet weak var colorLiteral: UIView!
    @IBOutlet weak var codeLabel: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        calloutLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("When calling the function, you pass an <b>argument</b> that the function uses to customize how it runs.", comment: "callout text"))

        // Touch up the appearance of the color literal.
        colorLiteral.layer.borderColor = UIColor.black.cgColor
        colorLiteral.layer.borderWidth = 1.0
        colorLiteral.layer.cornerRadius = 5.0

        // Make the callout pointer point down.
        calloutPointer.rotate(degrees: 180)

        calloutElements = [
            calloutLabel,
            calloutBubble,
            calloutPointer,
            highlightBubble
        ]

        // The callout fades in after a delay.
        calloutElements.forEach { $0.alpha = 0.0 }

        // Voiceover: Provide a description for the code which includes the color literal.
        let localizedLiteral = NSLocalizedString("green", comment: "the color green")
        codeLabel.accessibilityLabel = "paintRoom(color: \(localizedLiteral) )"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade in the callout.
        UIView.animate(withDuration: 0.4, delay: 1.0, options: [],
                       animations: {
                        self.calloutElements.forEach { $0.alpha = 1.0 }
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.calloutLabel)
        })
    }

    // MARK:- Private

    private var calloutElements: [UIView] = []
}
