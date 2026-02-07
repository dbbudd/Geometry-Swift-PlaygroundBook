//
//  LTC1_C01P01_Scene.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C01P01_Scene)
class LTC1_C01P01_Scene: SceneViewController {
    
    @IBOutlet weak var leftHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var primaryTextTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftHairline: UIView!
    @IBOutlet weak var rightHairline: UIView!
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    @IBOutlet weak var droneView: UIView!
    
    private var droneViewController: IntroDroneViewController?

    private var affectedByOpacityChange: [UIView] = []

    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Because "Learn to Code 1" and "Get Started with Code" share the same source,
        // but the title of the book is shown on the first page,
        // we need to be a little clever here to enable this to be localized,
        // without going to extreme measures.

        // "Learn to Code 1" and "Get Started with Code" have their own storyboards for chapter 1,
        // but both storyboards point to this source file.

        // The following 2 lines ensure that we have both titles in the Localized.strings files
        // for the localization process.
        let _ = NSLocalizedString("Get Started with Code", comment: "heading text: title of this playground")
        let _ = NSLocalizedString("Learn to Code 1", comment: "heading text: title of this playground")

        // Now, pull the string from the book-specific storyboard, to use as the key,
        // get the localized string for the user's locale,
        // and assign the localized string to the label.
        if let titleFromStoryboard = primaryTextLabel.text {
            primaryTextLabel.text = Bundle.main.localizedString(forKey: titleFromStoryboard, value: nil, table: nil)
        }

        secondaryTextLabel.text = NSLocalizedString("Commands", comment: "sub-heading text: title of this chapter")
        
        affectedByOpacityChange = [
               leftHairline,
               rightHairline,
               primaryTextLabel,
               secondaryTextLabel,
               droneView
           ]
        
        for v in affectedByOpacityChange {
            v.alpha = 0.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let affectedByMove: [NSLayoutConstraint] = [
            leftHairlineTopConstraint,
            rightHairlineTopConstraint,
            primaryTextTopConstraint
        ]
        
        for c in affectedByMove {
            c.constant += 65.0
        }
        
        view.setNeedsLayout()
                
        UIView.animate(withDuration: 0.6, delay: 0.45, options: [],
                       animations: {
                           for v in self.affectedByOpacityChange {
                               v.alpha = 1.0
                           }
                           // animate changes to constraints
                           self.view.layoutIfNeeded()
                       },
                       completion: { _ in
                           self.droneViewController?.startAnimation(completion: {
                            self.animationsDidComplete()
                           })
                       })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        droneViewController?.stopAnimation()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // The droneViewController is embedded as a child view controller
        // using a container view in the storyboard layout.
        if let controller = segue.destination as? IntroDroneViewController {
            droneViewController = controller
        }
    }

}
