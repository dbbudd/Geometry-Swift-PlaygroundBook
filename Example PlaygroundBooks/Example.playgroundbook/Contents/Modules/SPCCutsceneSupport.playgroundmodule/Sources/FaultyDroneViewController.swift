//
//  FaultyDroneViewController.swift
//
//  Copyright © 2019-2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(FaultyDroneViewController)
public class FaultyDroneViewController: UIViewController {

    @IBOutlet weak var RF_PropView: UIImageView!
    @IBOutlet weak var LR_PropView: UIImageView!
    @IBOutlet weak var LF_PropView: UIImageView!
    @IBOutlet weak var RR_PropView: UIImageView!

    @IBOutlet weak var flyaway_PropView: UIImageView!
    @IBOutlet weak var flyaway_TrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var flyaway_BottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var rockingView: UIView!
    @IBOutlet weak var shadowView: UIView!

    public var topMargin: CGFloat = 0.0
    public var leftMargin: CGFloat = 0.0

    // MARK:-

    public override func viewDidLoad() {
        super.viewDidLoad()

        // The flyaway prop is invisible at the start.
        flyaway_PropView.alpha = 0.0

        // Setup the shadow.
        let ovalPath = CGPath.init(ellipseIn: shadowView.bounds, transform: nil)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = ovalPath
        shadowView.layer.mask = shapeLayer
    }

    // MARK:-

    public func startAnimation(completion: (() -> Void)? = nil) {

        spinPropeller(in: RF_PropView)
        spinPropeller(in: flyaway_PropView)

        animateMalfunction(then: {
            self.detachPropFromDrone(then: {
                completion?()
            })
        })
     }

    // MARK:- Private

    private func animateMalfunction(then nextAnimation: @escaping () -> Void) {

        let animateFrames = UIView.keyframeAnimator(totalFrames: 18)

        UIView.animateKeyframes(withDuration: 0.6,
                                delay: 0.5,
                                options: [.beginFromCurrentState],
                                animations: {
                                    animateFrames(0, 3) {
                                        self.scale(self.shadowView, to: 0.8)
                                        self.translate(self.rockingView, yOffset: -6.0)
                                    }
                                    animateFrames(6, 12) {
                                        self.rockingView.rotate(degrees: -6.0)
                                    }
                                    animateFrames(3, 5) {
                                        self.scale(self.shadowView, to: 1.0)
                                        self.translate(self.rockingView, yOffset: 0.0)
                                    }
                                    animateFrames(5, 7) {
                                        self.scale(self.shadowView, to: 0.85)
                                        self.translate(self.rockingView, yOffset: -6.0)
                                    }
                                    animateFrames(7, 9) {
                                        self.scale(self.shadowView, to: 1.0)
                                        self.translate(self.rockingView, yOffset: 0.0)
                                    }
                                    animateFrames(12, 18) {
                                        self.rockingView.rotate(degrees: 12.0)
                                    }
                                    animateFrames(9, 15) {
                                        self.scale(self.shadowView, to: 0.71)
                                        self.translate(self.rockingView, yOffset: -18.0)
                                    }
                                    animateFrames(15, 18) {
                                        self.scale(self.shadowView, to: 1.0)
                                        self.translate(self.rockingView, yOffset: 11.0)
                                        self.translate(self.shadowView, yOffset: 15.0)
                                    }
        },
                                completion: { _ in
                                    nextAnimation()

                                    UIView.animate(withDuration: 0.15,
                                    animations: {
                                        // return to level
                                        self.rockingView.rotate(degrees: -6.0)
                                        self.translate(self.rockingView, yOffset: 0)
                                        self.translate(self.shadowView, yOffset: 0)
                                    })
        })
    }

    private func scale(_ theView: UIView, to scaleFactor: CGFloat) {

        let adjustment = scaleFactor / theView.transform.scaleX
        theView.scale(by: adjustment)
    }

    private func translate(_ theView: UIView, yOffset: CGFloat) {

        let adjustment = yOffset - theView.transform.ty
        theView.translate(xOffset: 0.0, yOffset: adjustment)
    }

    private func spinPropeller(in imageView: UIImageView) {

        let frontSequence = [
            UIImage(named: "prop-2")!,
            UIImage(named: "prop-1")!,
            UIImage(named: "prop-4")!,
            UIImage(named: "prop-3")!
        ]

        imageView.image = UIImage.animatedImage(with: frontSequence, duration: 0.2667)
    }

    private func stopPropeller(in imageView: UIImageView) {

        imageView.image = UIImage(named:"prop-0")
    }

    private func detachPropFromDrone(then completion: (() -> Void)? = nil) {

        RF_PropView.alpha = 0.0
        flyaway_PropView.alpha = 1.0

        CATransaction.begin()

        let path = UIBezierPath()
        path.move(to: flyaway_PropView.center)

        let offscreen: CGFloat = topMargin + flyaway_PropView.center.y
        let halfwayUp: CGFloat = offscreen / 2.0
        let center = CGPoint(x: flyaway_PropView.center.x, y: flyaway_PropView.center.y - halfwayUp)
        path.addArc(withCenter: center,
                    radius: halfwayUp,
                    startAngle: CGFloat(Double.pi * 0.5),
                    endAngle: CGFloat(Double.pi * 1.5),
                    clockwise: true)

        let moveAnimation = CAKeyframeAnimation(keyPath: "position")
        moveAnimation.path = path.cgPath
        moveAnimation.duration = 0.7

        flyaway_PropView.layer.add(moveAnimation, forKey: "move")

        CATransaction.commit()

        // IMPORTANT: The alpha change needs to be a UIView animation
        // so that the alpha value lasts beyond the end of the animation duration.
        UIView.animateKeyframes(withDuration: 0.7,
                                delay: 0.0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                                        self.flyaway_PropView.alpha = 0.0
                                    }
        },
                                completion: { _ in
                                    completion?()
        })

    }
}
