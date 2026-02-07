//
//  LTC1_C04P03_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C04P03_Scene)
class LTC1_C04P03_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var primaryTextBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var crosswalk: UIImageView!
    @IBOutlet weak var shadow: HoleView!

    @IBOutlet weak var trafficLight: UIImageView!

    @IBOutlet weak var containerViewCenterXConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        // The primary label contains styled text.
        primaryTextLabel.attributedText = attributedTextForPrimaryText()

        secondaryTextLabel.text = NSLocalizedString("If the light is green, Byte walks forward across the street.", comment: "descriptive text")

        // Capture the position of the primary text from the storyboard.
        primaryTextPosition = primaryTextBottomConstraint.constant

        // None of the text is visible at the start of the scene.
        primaryTextBottomConstraint.constant = -8.0
        secondaryTextLabel.alpha = 0.0

        // The crosswalk should be semi-transparent.
        crosswalk.alpha = 0.4

        // The shadow should be barely visible.
        shadow.alpha = 0.1

        crosswalk.makeAccessible(label: NSLocalizedString("traffic light turns green, Byte walks forward, across the street", comment: "accessibility label"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Scale Byte down to 85%.
        if let characterView = character?.view {
            characterView.transform = characterView.transform.scaledBy(x: 0.85, y: 0.85)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.75, delay: 0.25, options: [],
                       animations: {
                        self.primaryTextBottomConstraint.constant = self.primaryTextPosition
                        self.view.layoutIfNeeded()
        })

        UIView.animate(withDuration: 0.5, delay: 3.5, options: [],
                       animations: {
                        self.secondaryTextLabel.alpha = 1.0
        },
                       completion: { _ in
                        // Changing the image must be done in a completion block.
                        self.trafficLight.image = UIImage(named: "traffic-light-go")
        })

        character?.walk(for: 2.4, after: 4.9)
        UIView.animate(withDuration: 2.0, delay: 5.0, options: [],
                       animations: {
                        self.containerViewCenterXConstraint.constant += 660.0
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // The animated character is embedded using a container view,
        // capture the view controller object.
        character = segue.destination as? ByteCharacterViewController
    }

    // MARK:- Private

    private var character: ByteCharacterViewController?

    private var primaryTextPosition: CGFloat = 0

    private func attributedTextForPrimaryText() -> NSAttributedString {

        let text = NSLocalizedString("In code, you plan for different conditions using an <b>if statement</b>.", comment: "primary text; explaining when to use an if statement")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = primaryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
