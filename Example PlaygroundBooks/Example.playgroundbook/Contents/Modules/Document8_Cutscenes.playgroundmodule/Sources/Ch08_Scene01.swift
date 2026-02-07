//
//  Ch08_Scene01.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(Ch08_Scene01)
class Ch08_Scene01: SceneViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var leftHairline: UIView!
    @IBOutlet weak var rightHairline: UIView!
    @IBOutlet weak var leftHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftHairlineCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHairlineCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var circleView: SPCCircleView!
    @IBOutlet weak var circleLabel: UILabel!
    @IBOutlet weak var circleViewCenterYConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Because "Learn to Code 2" and "Get Started with Code" share the same source,
        // but the title of the book is shown on the first page,
        // we need to be a little clever here to enable this to be localized,
        // without going to extreme measures.
        
        // Learn to Code 2
        // title:    Learn to Code 2
        // subtitle: Variables
        
        // Get Started with Code
        // title:    Variables
        // subtitle: Storing Information

        // "Learn to Code 2" and "Get Started with Code" have their own storyboards for chapter 8,
        // but both storyboards point to this source file.

        // The following lines ensure that we have all the options we might need from the Localized.strings files
        // for the localization process.
        let _ = NSLocalizedString("Learn to Code 2", comment: "heading text: title of this playground")
        let _ = NSLocalizedString("Variables", comment: "heading text or sub-heading text")
        let _ = NSLocalizedString("Storing Information", comment: "sub-heading text")
        
        // Now, pull the string from the book-specific storyboard, to use as the key,
        // get the localized string for the user's locale,
        // and assign the localized string to the label.
        if let titleFromStoryboard = titleLabel.text {
            titleLabel.text = Bundle.main.localizedString(forKey: titleFromStoryboard, value: nil, table: nil)
        }
        
        if let subtitleFromStoryboard = subtitleLabel.text {
            subtitleLabel.text = Bundle.main.localizedString(forKey: subtitleFromStoryboard, value: nil, table: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Drop the hairline views into place.
        UIView.animate(withDuration: 0.5) {
            self.leftHairlineTopConstraint.constant += self.hairlineVertical
            self.rightHairlineTopConstraint.constant += self.hairlineVertical
            self.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.6, delay: 0.8, options: [],
                       animations: {
                        // Spread the hairline views apart.
                        self.leftHairlineCenterXConstraint.constant -= self.hairlineHorizontal
                        self.rightHairlineCenterXConstraint.constant += self.hairlineHorizontal

                        // Bring the circle view up into the center of the hairline views.
                        self.view.removeConstraint(self.circleViewCenterYConstraint)
                        NSLayoutConstraint.activate([
                            self.circleView.centerYAnchor.constraint(equalTo: self.leftHairline.centerYAnchor)
                        ])

                        self.view.layoutIfNeeded()
        })

        // Approximate flipping the circle view over by squashing it, then changing content and color.
        UIView.animate(withDuration: 0.2, delay: 1.4, options: [],
                       animations: {
                        self.circleView.transform = self.circleView.transform.scaledBy(x: 1.0, y: 0.0833)
                        self.circleLabel.alpha = 0.0
        },
                       completion: { _ in
                        self.circleView.backgroundColor = UIColor(named: "LTC2_Circle_Grey")!
                        self.circleLabel.text = "E"

                        UIView.animate(withDuration: 0.2,
                                       animations: {
                                        self.circleView.transform = self.circleView.transform.scaledBy(x: 1.0, y: 12.0)
                                        self.circleLabel.alpha = 1.0
                        },
                                       completion: { _ in
                                        // Signal that we have finished all animations.
                                        self.animationsDidComplete()
                        })
        })

        // Voiceover: Set the initial content.
        UIAccessibility.post(notification: .screenChanged, argument: titleLabel)
    }

    // MARK: - Private

    private let hairlineVertical: CGFloat = 65.0
    private let hairlineHorizontal: CGFloat = 48.0
}
