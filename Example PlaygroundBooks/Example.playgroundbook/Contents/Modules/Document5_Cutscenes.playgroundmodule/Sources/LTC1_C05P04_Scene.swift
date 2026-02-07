//
//  LTC1_C05P04_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C05P04_Scene)
class LTC1_C05P04_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var andLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var notLabel: UILabel!

    @IBOutlet weak var andWordLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var orWordLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var notWordLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var andSymbolTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var orSymbolTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var notSymbolTrailingConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("A logical operator is a type of an operator that you can use to make your conditional code more specific.\n\nEach of these three operators changes conditions in its own specific way:", comment: "primary text")
        
        andLabel.text = NSLocalizedString("AND", comment: "AND logical operator")
        orLabel.text = NSLocalizedString("OR", comment: "OR logical operator")
        notLabel.text = NSLocalizedString("NOT", comment: "NOT logical operator")

        // Capture the position of each of the words and symbols.
        andWordPosition = andWordLeadingConstraint.constant
        orWordPosition = orWordLeadingConstraint.constant
        notWordPosition = notWordLeadingConstraint.constant
        andSymbolPosition = andSymbolTrailingConstraint.constant
        orSymbolPosition = orSymbolTrailingConstraint.constant
        notSymbolPosition = notSymbolTrailingConstraint.constant

        // The words and symbols are not visible at the start of the scene.
        let offscreenPosition: CGFloat = -100.0
        andWordLeadingConstraint.constant = offscreenPosition
        orWordLeadingConstraint.constant = offscreenPosition
        notWordLeadingConstraint.constant = offscreenPosition
        andSymbolTrailingConstraint.constant = offscreenPosition
        orSymbolTrailingConstraint.constant = offscreenPosition
        notSymbolTrailingConstraint.constant = offscreenPosition
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animate in the pairs of words and symbols.
        animateChange(to: andWordLeadingConstraint, value: andWordPosition, duration: 0.4, delay: 1.0)
        animateChange(to: andSymbolTrailingConstraint, value: andSymbolPosition, duration: 0.4, delay: 1.0)

        animateChange(to: orWordLeadingConstraint, value: orWordPosition, duration: 0.4, delay: 2.0)
        animateChange(to: orSymbolTrailingConstraint, value: orSymbolPosition, duration: 0.4, delay: 2.0)

        animateChange(to: notWordLeadingConstraint, value: notWordPosition, duration: 0.4, delay: 3.0)
        animateChange(to: notSymbolTrailingConstraint, value: notSymbolPosition, duration: 0.4, delay: 3.0, then: {
            self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

    // MARK:- Private

    private var andWordPosition: CGFloat = 0.0
    private var orWordPosition: CGFloat = 0.0
    private var notWordPosition: CGFloat = 0.0

    private var andSymbolPosition: CGFloat = 0.0
    private var orSymbolPosition: CGFloat = 0.0
    private var notSymbolPosition: CGFloat = 0.0
}
