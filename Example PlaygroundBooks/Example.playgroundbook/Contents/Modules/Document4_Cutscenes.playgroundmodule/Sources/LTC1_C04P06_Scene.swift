//
//  LTC1_C04P06_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C04P06_Scene)
class LTC1_C04P06_Scene: SceneViewController {

    @IBOutlet weak var crosswalk: UIImageView!
    @IBOutlet weak var shadow: HoleView!

    @IBOutlet weak var trafficLight: UIImageView!

    @IBOutlet weak var ifExprLabel: UILabel!
    @IBOutlet weak var moveCommandLabel: UILabel!
    @IBOutlet weak var waitCommandLabel: UILabel!
    @IBOutlet weak var ifBlockEndLabel: UILabel!
    @IBOutlet weak var elseLabel: UILabel!
    @IBOutlet weak var elseBlockBeginLabel: UILabel!
    @IBOutlet weak var elseBlockEndLabel: UILabel!

    @IBOutlet weak var elseBubble: UIView!
    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutTextBubble: UIView!
    @IBOutlet weak var calloutBubblePointer: UIView!
    
    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        codeElements = [ ifExprLabel,
                         moveCommandLabel,
                         ifBlockEndLabel,
                         elseLabel,
                         elseBlockBeginLabel,
                         waitCommandLabel,
                         elseBlockEndLabel ]

        // The code is not visible at the start of the scene.
        for element in codeElements {
            element.alpha = 0.0
        }

        calloutTextLabel.attributedText = attributedTextForCallout()
        calloutBubblePointer.rotate(degrees: 45.0)
        calloutElements = [ elseBubble,
                            calloutTextLabel,
                            calloutTextBubble,
                            calloutBubblePointer ]

        // The callout is not visible at the start of the scene.
        for element in calloutElements {
            element.alpha = 0.0
        }

        // The crosswalk should be semi-transparent.
        crosswalk.alpha = 0.4

        // The shadow should be barely visible.
        shadow.alpha = 0.1

        crosswalk.makeAccessible(label: NSLocalizedString("Byte standing at crosswalk while light is red", comment: "accessibility label"))

        view.accessibilityElements = [ calloutTextLabel!,
                                       ifExprLabel!,
                                       moveCommandLabel!,
                                       ifBlockEndLabel!,
                                       elseLabel!,
                                       elseBlockBeginLabel!,
                                       waitCommandLabel!,
                                       elseBlockEndLabel!,
                                       crosswalk! ]
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

        // Fade in the code.
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [],
                       animations: {
                        for element in self.codeElements {
                            element.alpha = 1.0
                        }
        })

        // Fade in the callout.
        UIView.animate(withDuration: 0.5, delay: 1.5, options: [],
                       animations: {
                        for element in self.calloutElements {
                            element.alpha = 1.0
                        }
        },
                       completion: { _ in
                        UIAccessibility.post(notification: .screenChanged, argument: self.calloutTextLabel)
                        self.animationsDidComplete()
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // The animated character is embedded using a container view,
        // capture the view controller object.
        character = segue.destination as? ByteCharacterViewController
    }

    // MARK:- Private

    private var character: ByteCharacterViewController?

    private var codeElements: [UIView] = []
    private var calloutElements: [UIView] = []

    private func attributedTextForCallout() -> NSAttributedString {

        let text = NSLocalizedString("If the condition is <b>false</b>, you can use <cv>else</cv> to specify other code to run.", comment: "callout text; explaining code in an if else block")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = calloutTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
