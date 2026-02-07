//
//  Ch10_Scene04.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch10_Scene04)
class Ch10_Scene04: SceneViewController {

    @IBOutlet weak var declarationCalloutLabel: UILabel!
    @IBOutlet weak var declarationCalloutPointer: SPCTriangleView!
    @IBOutlet weak var declarationCalloutBubble: UIView!

    @IBOutlet weak var initializationCalloutLabel: UILabel!
    @IBOutlet weak var initializationCalloutPointer: SPCTriangleView!
    @IBOutlet weak var initializationCalloutBubble: UIView!

    @IBOutlet weak var declarationHighlight: UIView!
    @IBOutlet weak var initializationHighlight: UIView!

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        // Rotate the pointer views to point down.
        declarationCalloutPointer.rotate(degrees: 180)
        initializationCalloutPointer.rotate(degrees: 180)

        primaryTextLabel.setAttributedText(xmlAnnotatedString: NSLocalizedString("To create an instance of your expert, first declare a constant using <b>let</b>, then initialize it with the type name followed by ().", comment: "primary text"))

        declarationCalloutLabel.text = NSLocalizedString("declaration", comment: "callout text")

        initializationCalloutLabel.text = NSLocalizedString("initialization", comment: "callout text")

        calloutElements = [
            declarationHighlight,
            declarationCalloutLabel,
            declarationCalloutBubble,
            declarationCalloutPointer,
            initializationHighlight,
            initializationCalloutLabel,
            initializationCalloutBubble,
            initializationCalloutPointer
        ]

        // The callout elements are not visible at the start of the scene.
        calloutElements.forEach { $0.alpha = 0.0 }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.5, delay: 1.5, options: [],
                       animations: {
                        self.calloutElements.forEach { $0.alpha = 1.0 }
        },
                       completion: { _ in
                        self.animationsDidComplete()

                        // Voiceover: Set the initial content.
                        UIAccessibility.post(notification: .screenChanged,
                                             argument: self.primaryTextLabel)
        })
    }

    // MARK:- Private

    private var calloutElements: [UIView] = []
}
