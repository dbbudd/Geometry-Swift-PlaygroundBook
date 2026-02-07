//
//  LTC1_C01P08_Scene.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C01P08_Scene)
class LTC1_C01P08_Scene: SceneViewController {
    
    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutTextBubble: UIView!
    @IBOutlet weak var calloutTextPointer: UIView!
    
    @IBOutlet weak var codeSnippetLabel: UILabel!
    @IBOutlet weak var codeSnippetBubble: UIView!

    @IBOutlet weak var parenthesesBubble: UIView!

    @IBOutlet weak var secondCalloutLabel: UILabel!
    @IBOutlet weak var secondCalloutBubble: UIView!
    @IBOutlet weak var secondCalloutPointer: UIView!
    
    // MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calloutTextLabel.text = NSLocalizedString("Notice the mashed-together words? Code is punctuated and spaced like human languages, but commands have no spaces between words.", comment: "callout; describes a snippet of code")
        secondCalloutLabel.text = NSLocalizedString("Commands always end in parentheses. You’ll see why later!", comment: "callout; describes a snippet of code")
        
        // The callout bubble needs a little pointer, like a popup
        // so, rotate a square view 45º.
        calloutTextPointer.rotate(degrees: 45.0)
        secondCalloutPointer.rotate(degrees: 45.0)
        
        // Setup initial state.
        secondCalloutLabel.alpha = 0.0
        secondCalloutBubble.alpha = 0.0
        secondCalloutPointer.alpha = 0.0
        parenthesesBubble.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.5,
                       delay: 3.0,
                       options: [],
                       animations: {
                        self.secondCalloutLabel.alpha = 1.0
                        self.secondCalloutBubble.alpha = 1.0
                        self.secondCalloutPointer.alpha = 1.0
                        self.parenthesesBubble.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: calloutTextLabel)
    }
    
}
