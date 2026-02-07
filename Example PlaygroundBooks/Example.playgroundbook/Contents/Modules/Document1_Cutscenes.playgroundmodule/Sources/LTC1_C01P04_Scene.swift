//
//  LTC1_C01P04_Scene.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C01P04_Scene)
class LTC1_C01P04_Scene: SceneViewController {
    
    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!

    private var droneViewController: FaultyDroneViewController?
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        primaryTextLabel.text = NSLocalizedString("You need to follow the instructions in the correct order, or you’ll end up with something … unexpected.", comment: "primary text")

        containerView.makeAccessible(label: NSLocalizedString("drone with four propellers. oh dear, make that three propellers. one of the propellers has flown off.", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let delay = DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + UInt64(1.5 * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.droneViewController?.startAnimation(completion: {
                self.animationsDidComplete()
            })
        }

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
  }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // The droneViewController is embedded as a child view controller
        // using a container view in the storyboard layout.
        if let controller = segue.destination as? FaultyDroneViewController {
            controller.leftMargin = (self.view.bounds.width - containerView.bounds.width) / 2.0
            controller.topMargin = containerViewTopConstraint.constant
            droneViewController = controller
        }
    }
}
