//
//  LTC1_C04P02_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C04P02_Scene)
class LTC1_C04P02_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var primaryTextBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var redCarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var orangeCarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var truckBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var whiteCarBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var blackCar: UIImageView!
    @IBOutlet weak var blackCarCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var blackCarCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var shadow: UIImageView!
    @IBOutlet weak var shadowCenterYConstraint: NSLayoutConstraint!

    @IBOutlet weak var gpsImageView: UIImageView!
    @IBOutlet weak var roadwaysImageView: UIImageView!

    @IBOutlet weak var gpsPopupView: UIView!
    @IBOutlet weak var gpsPopupLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var gpsMarkerView: UIImageView!
    @IBOutlet weak var gpsMarkerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var gpsMarkerLeadingConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("If you hit a traffic jam, you may need to change your route.", comment: "primary text; explains the scene")

        // Capture the text's vertical position from the storyboard.
        primaryTextPosition = primaryTextBottomConstraint.constant

        // Move the text offscreen for the start of the scene.
        primaryTextBottomConstraint.constant = -8.0

        // The minimap is invisible at the start of the scene,
        // and will scale in when it appears.
        setupPopupAppearance(on: gpsPopupView)
        gpsPopupView.scale(by: 0.125)
        gpsPopupView.alpha = 0.0

        // The minimap position marker is introduced later than the rest of the minimap.
        gpsMarkerView.alpha = 0.0

        roadwaysImageView.makeAccessible(label: NSLocalizedString("roadway with heavy traffic", comment: "accessibility label"))
        gpsImageView.makeAccessible(label: NSLocalizedString("car gee pee ess shows quicker route. car follows this quicker route.", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animate the text in, with bounce.
        adjust(primaryTextBottomConstraint, to: primaryTextPosition, duration: 1.0, delay: 0.3, bounce: 18.0)

        let animateFrames = UIView.keyframeAnimator(totalFrames: 420)
        UIView.animateKeyframes(withDuration: 14.0, delay: 0.0, options: [],
                                animations: {
                                    // Animate the movement of the vehicles.
                                    animateFrames(0,60) {
                                        self.redCarBottomConstraint.constant -= 16.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(0,75) {
                                        self.truckBottomConstraint.constant -= 9.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(0,90) {
                                        self.whiteCarBottomConstraint.constant -= 4.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(60,90) {
                                        self.orangeCarBottomConstraint.constant -= 10.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(90,150) {
                                        self.redCarBottomConstraint.constant -= 36.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(105,180) {
                                        self.truckBottomConstraint.constant -= 44.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(120,180) {
                                        self.whiteCarBottomConstraint.constant -= 46.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(120, 159) {
                                        self.blackCarCenterYConstraint.constant -= 172.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(135,180) {
                                        self.orangeCarBottomConstraint.constant -= 12.0
                                        self.view.layoutIfNeeded()
                                    }
                                    // Animate the minimap/gps.
                                    animateFrames(180,189) {
                                        self.gpsPopupView.alpha = 1.0
                                        self.gpsPopupView.scale(by: 5.0)
                                    }
                                    animateFrames(189,192) {
                                        self.gpsPopupView.scale(by: 0.8)
                                    }
                                    animateFrames(210,219) {
                                        self.gpsPopupLeadingConstraint.constant -= 468.0
                                        self.gpsPopupView.scale(by: 2.0)
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(222,231) {
                                        self.gpsMarkerView.alpha = 1.0
                                    }
                                    animateFrames(270,292) {
                                        self.gpsMarkerView.rotate(degrees: 45.0) // 45
                                        self.gpsMarkerTopConstraint.constant -= 30.0
                                        self.gpsMarkerLeadingConstraint.constant += 21.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(292,309) {
                                        self.gpsMarkerView.rotate(degrees: 10.0) // 55
                                        self.gpsMarkerTopConstraint.constant -= 17.0
                                        self.gpsMarkerLeadingConstraint.constant += 23.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(309,312) {
                                        self.gpsMarkerView.rotate(degrees: -10.0) // 45
                                        self.gpsMarkerTopConstraint.constant -= 6.0
                                        self.gpsMarkerLeadingConstraint.constant += 9.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(312,315) {
                                        self.gpsMarkerView.rotate(degrees: -15.0) // 30
                                        self.gpsMarkerTopConstraint.constant -= 8.0
                                        self.gpsMarkerLeadingConstraint.constant += 8.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(315,318) {
                                        self.gpsMarkerView.rotate(degrees: -5.0) // 25
                                        self.gpsMarkerTopConstraint.constant -= 10.0
                                        self.gpsMarkerLeadingConstraint.constant += 5.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(318,321) {
                                        self.gpsMarkerView.rotate(degrees: -9.0) // 16
                                        self.gpsMarkerTopConstraint.constant -= 12.0
                                        self.gpsMarkerLeadingConstraint.constant += 3.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(321,324) {
                                        self.gpsMarkerView.rotate(degrees: -7.0) // 8
                                        self.gpsMarkerTopConstraint.constant -= 13.0
                                        self.gpsMarkerLeadingConstraint.constant += 3.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(324,327) {
                                        self.gpsMarkerView.rotate(degrees: -10.0) // -2
                                        self.gpsMarkerTopConstraint.constant -= 13.0
                                        self.gpsMarkerLeadingConstraint.constant += 1.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(327,336) {
                                        self.gpsMarkerView.rotate(degrees: -2.0) // -4
                                        self.gpsMarkerTopConstraint.constant -= 39.0
                                        self.gpsMarkerLeadingConstraint.constant -= 1.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(336,342) {
                                        self.gpsMarkerView.rotate(degrees: -3.0) // -7
                                        self.gpsMarkerTopConstraint.constant -= 27.0
                                        self.gpsMarkerLeadingConstraint.constant -= 3.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(342,345) {
                                        self.gpsMarkerView.rotate(degrees: -23.0) // -30
                                        self.gpsMarkerTopConstraint.constant -= 12.0
                                        self.gpsMarkerLeadingConstraint.constant -= 2.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(345,348) {
                                        self.gpsMarkerView.rotate(degrees: -15.0) // -45
                                        self.gpsMarkerTopConstraint.constant -= 10.0
                                        self.gpsMarkerLeadingConstraint.constant -= 5.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(348,354) {
                                        self.gpsMarkerView.rotate(degrees: -10.0) // -55
                                        self.gpsMarkerTopConstraint.constant -= 12.0
                                        self.gpsMarkerLeadingConstraint.constant -= 16.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(354,360) {
                                        self.gpsMarkerView.rotate(degrees: -5.0) // -60
                                        self.gpsMarkerTopConstraint.constant -= 7.0
                                        self.gpsMarkerLeadingConstraint.constant -= 17.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(360,369) {
                                        self.gpsMarkerView.rotate(degrees: 25.0) // -35
                                        self.gpsMarkerTopConstraint.constant -= 10.0
                                        self.gpsMarkerLeadingConstraint.constant -= 25.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(369,384) {
                                        self.gpsMarkerView.rotate(degrees: 35.0) // 0
                                        self.gpsMarkerTopConstraint.constant -= 20.0
                                        self.gpsMarkerLeadingConstraint.constant -= 3.0
                                        self.view.layoutIfNeeded()
                                    }
                                    // Animate the black car, and its shadow.
                                    animateFrames(270,321) {
                                        self.blackCar.rotate(degrees: 90.0)
                                        self.shadow.rotate(degrees: 90.0)
                                        self.shadowCenterYConstraint.constant = 4.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(270,273) {
                                        self.blackCarCenterYConstraint.constant -= 25.0
                                        self.blackCarCenterXConstraint.constant += 2.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(273,276) {
                                        self.blackCarCenterYConstraint.constant -= 25.0
                                        self.blackCarCenterXConstraint.constant += 4.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(276,279) {
                                        self.blackCarCenterYConstraint.constant -= 24.0
                                        self.blackCarCenterXConstraint.constant += 7.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(279,282) {
                                        self.blackCarCenterYConstraint.constant -= 22.0
                                        self.blackCarCenterXConstraint.constant += 10.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(282,285) {
                                        self.blackCarCenterYConstraint.constant -= 22.0
                                        self.blackCarCenterXConstraint.constant += 11.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(285,288) {
                                        self.blackCarCenterYConstraint.constant -= 20.0
                                        self.blackCarCenterXConstraint.constant += 14.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(288,291) {
                                        self.blackCarCenterYConstraint.constant -= 19.0
                                        self.blackCarCenterXConstraint.constant += 15.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(291,294) {
                                        self.blackCarCenterYConstraint.constant -= 18.0
                                        self.blackCarCenterXConstraint.constant += 17.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(294,297) {
                                        self.blackCarCenterYConstraint.constant -= 16.0
                                        self.blackCarCenterXConstraint.constant += 18.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(297,300) {
                                        self.blackCarCenterYConstraint.constant -= 14.0
                                        self.blackCarCenterXConstraint.constant += 20.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(300,303) {
                                        self.blackCarCenterYConstraint.constant -= 11.0
                                        self.blackCarCenterXConstraint.constant += 22.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(303,306) {
                                        self.blackCarCenterYConstraint.constant -= 10.0
                                        self.blackCarCenterXConstraint.constant += 22.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(306,309) {
                                        self.blackCarCenterYConstraint.constant -= 8.0
                                        self.blackCarCenterXConstraint.constant += 24.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(309,312) {
                                        self.blackCarCenterYConstraint.constant -= 6.0
                                        self.blackCarCenterXConstraint.constant += 24.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(312,315) {
                                        self.blackCarCenterYConstraint.constant -= 4.0
                                        self.blackCarCenterXConstraint.constant += 25.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(315,318) {
                                        self.blackCarCenterYConstraint.constant -= 2.0
                                        self.blackCarCenterXConstraint.constant += 25.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(318,321) {
                                        self.blackCarCenterYConstraint.constant -= 1.0
                                        self.blackCarCenterXConstraint.constant += 25.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(321,324) {
                                        self.blackCarCenterYConstraint.constant -= 1.0
                                        self.blackCarCenterXConstraint.constant += 25.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(324,327) {
                                        self.blackCarCenterYConstraint.constant -= 1.0
                                        self.blackCarCenterXConstraint.constant += 25.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(327,330) {
                                        self.blackCarCenterYConstraint.constant -= 0
                                        self.blackCarCenterXConstraint.constant += 25.0
                                        self.view.layoutIfNeeded()
                                    }
                                    // Animate the vehicle traffic.
                                    animateFrames(330,390) {
                                        self.redCarBottomConstraint.constant -= 60.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(345,405) {
                                        self.orangeCarBottomConstraint.constant -= 36.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(375,420) {
                                        self.truckBottomConstraint.constant -= 60.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(390,420) {
                                        self.whiteCarBottomConstraint.constant -= 56.0
                                        self.view.layoutIfNeeded()
                                    }
        },
                                completion: { _ in
                                    self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: roadwaysImageView)
    }

    // MARK:- Private

    private var primaryTextPosition: CGFloat = 0.0

    private func adjust(_ constraint: NSLayoutConstraint, to value: CGFloat, duration: TimeInterval, delay: TimeInterval, bounce: CGFloat) {

        UIView.animate(withDuration: (0.7 * duration), delay: 0.3, options: [],
                       animations: {
                        constraint.constant = value + bounce
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        UIView.animate(withDuration: (0.3 * duration)) {
                            constraint.constant -= bounce
                            self.view.layoutIfNeeded()
                        }
        })
    }

    private func setupPopupAppearance(on theView: UIView) {

        let fillColor = UIColor(named: "LTC1_Ch4_MapPopup")!

        // Add the circle.
        let oval = CAShapeLayer()
        oval.path = UIBezierPath(ovalIn: theView.bounds).cgPath
        oval.fillColor = fillColor.cgColor
        theView.layer.insertSublayer(oval, at: 0)

        // Add the pointer.
        let pointer = UIView(frame: .zero)
        pointer.backgroundColor = fillColor
        pointer.translatesAutoresizingMaskIntoConstraints = false
        theView.insertSubview(pointer, at: 0)

        let width = theView.bounds.width * 0.25
        NSLayoutConstraint.activate([
            pointer.widthAnchor.constraint(equalToConstant: width),
            pointer.heightAnchor.constraint(equalToConstant: width),
            pointer.centerXAnchor.constraint(equalTo: theView.centerXAnchor),
            pointer.centerYAnchor.constraint(equalTo: theView.bottomAnchor, constant: -0.18 * width)
        ])

        pointer.rotate(degrees: 45.0)

        theView.layoutIfNeeded()
    }
}
