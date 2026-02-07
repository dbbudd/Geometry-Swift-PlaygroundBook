//
//  Ch11_Scene06.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch11_Scene06)
class Ch11_Scene06: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var primaryTextTop: NSLayoutConstraint!

    @IBOutlet weak var declarationLabel: UILabel!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var colorLiteral: UIView!

    @IBOutlet weak var paintRollerBottom: NSLayoutConstraint!

    @IBOutlet weak var firstLayerHeight: NSLayoutConstraint!
    @IBOutlet weak var secondLayerHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdLayerHeight: NSLayoutConstraint!

    @IBOutlet weak var highlightBubble: UIView!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: SPCTriangleView!
    @IBOutlet weak var calloutLabel: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("Your function can have multiple parameters.", comment: "primary text")

        calloutLabel.text = NSLocalizedString("Now you can pass in a color for the room, and the number of layers you want, all with the same function!", comment: "text in callout bubble")

        // Touch up the appearance of the color literal.
        colorLiteral.layer.borderColor = UIColor.black.cgColor
        colorLiteral.layer.borderWidth = 1.0
        colorLiteral.layer.cornerRadius = 5.0

        functionCallElements = [
            callLabel,
            colorLiteral
        ]

        calloutElements = [
            highlightBubble,
            calloutBubble,
            calloutPointer,
            calloutLabel
        ]

        // These elements are invisible at the start of the scene.
        functionCallElements.forEach { $0.alpha = 0.0 }
        calloutElements.forEach { $0.alpha = 0.0 }

        // The primary text drops in after the scene starts.
        primaryTextLabel.alpha = 0.0
        primaryTextTop.constant = -512.0

        // The paint roller pops up after the scene starts.
        paintRollerBottom.constant = -512.0

        self.view.layoutIfNeeded()

        // Voiceover: Provide description of the code which includes the color literal.
        let localizedLiteral = NSLocalizedString("blue", comment: "the color blue")
        callLabel.accessibilityLabel = "paintRoom(color: \(localizedLiteral), layers: 3)"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade in the primary text.
        UIView.animate(withDuration: 0.3, delay: 0.7, options: [],
                       animations: {
                        self.primaryTextLabel.alpha = 1.0
        })

        // Drop in the primary text.
        animateChange(to: primaryTextTop, value: 76.0, duration: 0.5, delay: 0.7)

        // Bring up the paint roller.
        animateChange(to: paintRollerBottom, value: 0, duration: 0.5, delay: 0.7, then: {

            // Fade out the function declaration.
            UIView.animate(withDuration: 0.3, delay: 2.0, options: [],
                           animations: {
                            self.declarationLabel.alpha = 0.0
            })

            // Fade in the function call.
            UIView.animate(withDuration: 0.3, delay: 2.5, options: [],
                           animations: {
                            self.functionCallElements.forEach { $0.alpha = 1.0 }
            })

            // Fade in the callout.
            UIView.animate(withDuration: 0.5, delay: 3.0, options: [],
                           animations: {
                            self.calloutElements.forEach { $0.alpha = 1.0 }
            },
                           completion: { _ in
                            // Voiceover: Set the initial content.
                            UIAccessibility.post(notification: .screenChanged,
                                                 argument: self.primaryTextLabel)
            })

            // Move the roller up, and paint.
            UIView.animate(withDuration: 0.8, delay: 4.5, options: [],
                            animations: {
                             self.paintRollerBottom.constant += self.paintHeight - self.rollerHeight
                             self.firstLayerHeight.constant += self.paintHeight
                             self.view.layoutIfNeeded()
             })

             // Move the roller down, and paint.
            UIView.animate(withDuration: 0.8, delay: 5.7, options: [],
                            animations: {
                             self.paintRollerBottom.constant -= self.paintHeight - self.rollerHeight
                             self.secondLayerHeight.constant += self.paintHeight
                             self.view.layoutIfNeeded()
             })

             // Move the roller up, and paint.
            UIView.animate(withDuration: 0.8, delay: 6.9, options: [],
                            animations: {
                             self.paintRollerBottom.constant += self.paintHeight - self.rollerHeight
                             self.thirdLayerHeight.constant += self.paintHeight
                             self.view.layoutIfNeeded()
             },
                            completion: { _ in
                             self.animationsDidComplete()
             })
        })
    }
    
    // MARK:- Private

    private let paintHeight: CGFloat = 234.0
    private let rollerHeight: CGFloat = 48.0

    private var functionCallElements: [UIView] = []
    private var calloutElements: [UIView] = []
}
