//
//  ByteCharacterViewController.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(ByteCharacterViewController)
public class ByteCharacterViewController: UIViewController {

    @IBOutlet weak var core: UIImageView!
    @IBOutlet weak var neck: UIImageView!
    @IBOutlet weak var head: UIImageView!
    @IBOutlet weak var eye: UIImageView!
    @IBOutlet weak var mouth: UIImageView!
    @IBOutlet weak var leftArm: UIImageView!
    @IBOutlet weak var rightArm: UIImageView!
    @IBOutlet weak var leftLeg: UIImageView!
    @IBOutlet weak var rightLeg: UIImageView!

    // MARK:- Animation Control

    public func walk(for duration: TimeInterval, after delay: TimeInterval = 0.0) {

        setupWalkAnimations(duration: duration, delay: delay)
    }

    public func jump(for duration: TimeInterval, after delay: TimeInterval) {

        setupJumpAnimations(duration: duration, delay: delay)
    }

    // MARK:- Private

    private func setupWalkAnimations(duration: TimeInterval, delay: TimeInterval) {

        // Adjust anchor points on component views to get proper rotation.
        setupAnchorPoints()

        // Get keyframe animation helper.
        let animateFrames = UIView.keyframeAnimator(totalFrames: 62)

        // Setup animations.
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: .beginFromCurrentState,
                                animations: {

                                    animateFrames(0, 5) {
                                        self.rotateBodyBack()
                                        self.rotateLeftArmBack()
                                        self.rotateRightArmForward()
                                        self.rotateRightLegBack()
                                        self.rotateLeftLegForward()
                                    }
                                    animateFrames(5, 10) {
                                        self.rotateRightLegForward()
                                        self.rotateLeftLegBack()
                                    }
                                    animateFrames(5, 12) {
                                        self.rotateBodyToNeutral()
                                        self.rotateLeftArmToNeutral()
                                        self.rotateRightArmBack()
                                    }
                                    animateFrames(10, 15) {
                                        self.rotateRightLegBack()
                                        self.rotateLeftLegForward()
                                    }
                                    animateFrames(12, 17) {
                                        self.rotateBodyBack()
                                        self.rotateLeftArmBack()
                                        self.rotateRightArmForward()
                                    }
                                    animateFrames(15, 22) {
                                        self.rotateRightLegForward()
                                        self.rotateLeftLegBack()
                                    }
                                    animateFrames(17, 23) {
                                        self.rotateBodyToNeutral()
                                        self.rotateLeftArmToNeutral()
                                        self.rotateRightArmBack()
                                    }
                                    animateFrames(22, 27) {
                                        self.rotateRightLegBack()
                                        self.rotateLeftLegForward()
                                    }
                                    animateFrames(23, 29) {
                                        self.rotateBodyBack()
                                        self.rotateLeftArmBack()
                                        self.rotateRightArmForward()
                                    }
                                    animateFrames(27, 34) {
                                        self.rotateRightLegForward()
                                        self.rotateLeftLegBack()
                                    }
                                    animateFrames(29, 34) {
                                        self.rotateBodyToNeutral()
                                        self.rotateLeftArmToNeutral()
                                        self.rotateRightArmBack()
                                    }
                                    animateFrames(34, 39) {
                                        self.rotateRightLegBack()
                                        self.rotateLeftLegForward()
                                    }
                                    animateFrames(34, 41) {
                                        self.rotateBodyBack()
                                        self.rotateLeftArmBack()
                                        self.rotateRightArmForward()
                                    }
                                    animateFrames(39, 46) {
                                        self.rotateRightLegForward()
                                        self.rotateLeftLegBack()
                                    }
                                    animateFrames(41, 46) {
                                        self.rotateBodyToNeutral()
                                        self.rotateLeftArmToNeutral()
                                        self.rotateRightArmBack()
                                    }
                                    animateFrames(46, 51) {
                                        self.rotateRightLegBack()
                                        self.rotateLeftLegForward()
                                    }
                                    animateFrames(46, 52) {
                                        self.rotateBodyBack()
                                        self.rotateRightArmForward()
                                    }
                                    animateFrames(51, 62) {
                                        self.rotateRightLegToNeutral()
                                        self.rotateLeftLegToNeutral()
                                    }
                                    animateFrames(51, 57) {
                                        self.rotateBodyToNeutral()
                                        self.rotateRightArmToNeutral()
                                    }
        })
    }

    private func setupJumpAnimations(duration: TimeInterval, delay: TimeInterval) {

        // Adjust anchor points on component views to get proper rotation.
        setupAnchorPoints()

        // Get keyframe animation helper.
        let animateFrames = UIView.keyframeAnimator(totalFrames: 30)

        // Setup animations.
        UIView.animateKeyframes(withDuration: duration, delay: delay,
                                    options: [.beginFromCurrentState, .overrideInheritedDuration],
                                    animations: {

                                        animateFrames(0, 8) {
                                            // crouch
                                            self.mouth.translate(yOffset: 10)
                                            self.core.translate(yOffset: 11)
                                            self.eye.translate(yOffset: 28)
                                            self.head.translate(yOffset: 27)
                                            self.neck.translate(yOffset: 25)
                                            self.rotate(self.leftArm, to: 12)
                                            self.rotate(self.rightArm, to: -16)

                                        }
                                        animateFrames(8, 17) {
                                            // fly up
                                            self.rotate(self.leftLeg, to: -15)
                                            self.rotate(self.rightLeg, to: 20)
                                            self.rotate(self.leftArm, to: -5)
                                            self.rotate(self.rightArm, to: 6)
                                        }
                                        animateFrames(17, 25) {
                                            // fall back to earth
                                            self.rotate(self.leftLeg, to: 0)
                                            self.rotate(self.rightLeg, to: 0)
                                            self.rotate(self.leftArm, to: 6)
                                            self.rotate(self.rightArm, to: -8)
                                        }
                                        animateFrames(25, 30) {
                                            // straighten up
                                            self.mouth.translate(yOffset: -10)
                                            self.core.translate(yOffset: -11)
                                            self.eye.translate(yOffset: -28)
                                            self.head.translate(yOffset: -27)
                                            self.neck.translate(yOffset: -25)
                                            self.rotate(self.leftArm, to: -10)
                                            self.rotate(self.leftArm, to: 0)
                                            self.rotate(self.rightArm, to: 0)
                                        }
        })
    }

    private func setupAnchorPoints() {

        // Anchor points are specified in unit coordinate space (0.0, 0.0) to (1.0, 1.0).

        leftArm.setAnchorPoint(CGPoint(x: 0.7778, y: 0.1228))
        rightArm.setAnchorPoint(CGPoint(x: 0.2069, y: 0.1228))
        leftLeg.setAnchorPoint(CGPoint(x: 0.5, y: 0.1087))
        rightLeg.setAnchorPoint(CGPoint(x: 0.5, y: 0.1087))
    }

    private func rotateBodyBack() {
        // Rotate the whole view.
        rotate(view, to: -6.0)
    }

    private func rotateBodyToNeutral() {
        // Rotate the whole view.
        rotate(view, to: 0.0)
    }

    private func rotateLeftArmBack() {
        rotate(leftArm, to: 12.0)
    }

    private func rotateLeftArmToNeutral() {
        rotate(leftArm, to: 0.0)
    }

    private func rotateLeftLegBack() {
        rotate(leftLeg, to: 8.0)
    }

    private func rotateLeftLegToNeutral() {
        rotate(leftLeg, to: 0.0)
    }

    private func rotateLeftLegForward() {
        rotate(leftLeg, to: -40.0)
    }

    private func rotateRightArmBack() {
        rotate(rightArm, to: -12)
    }

    private func rotateRightArmToNeutral() {
        rotate(rightArm, to: 0.0)
    }

    private func rotateRightArmForward() {
        rotate(rightArm, to: 6.0)
    }

    private func rotateRightLegBack() {
        rotate(rightLeg, to: 25.0)
    }

    private func rotateRightLegToNeutral() {
        rotate(rightLeg, to: 0.0)
    }

    private func rotateRightLegForward() {
        rotate(rightLeg, to: -30.0)
    }

    // MARK:- Utility

    private func rotate(_ thisView: UIView, to angleInDegrees: CGFloat) {

        let existing = thisView.transform
        thisView.transform = CGAffineTransform(rotationAngle: deg2Rad(angleInDegrees))
                             .scaledBy(x: existing.scaleX, y: existing.scaleY)
                             .translatedBy(x: existing.tx, y: existing.ty)
    }
}
