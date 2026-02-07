//
//  LTC1_C05P02_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C05P02_Scene)
class LTC1_C05P02_Scene: SceneViewController {

    @IBOutlet weak var crosswalk: UIImageView!
    @IBOutlet weak var shadow: HoleView!

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.attributedText = attributedTextForPrimaryText()

        // The crosswalk should be semi-transparent.
        crosswalk.alpha = 0.4

        // The shadow should be barely visible.
        shadow.alpha = 0.1

        crosswalk.makeAccessible(label: NSLocalizedString("Byte waits at a red light.", comment: "accessibility label"))
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

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
        animationsDidComplete()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // The animated character is embedded using a container view,
        // capture the view controller object.
        character = segue.destination as? ByteCharacterViewController
    }

    // MARK:- Private

    private var character: ByteCharacterViewController?

    private func attributedTextForPrimaryText() -> NSAttributedString {

        let text = NSLocalizedString("Earlier, you used an <b>if statement</b> to plan for different situations. But what if you could make your conditional code even more powerful?", comment: "primary text")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = primaryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
