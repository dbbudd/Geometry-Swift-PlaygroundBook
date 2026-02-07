//
//  UIView+Cutscenes.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

public extension UIView {

    // MARK: - Animation

    /// An animation helper, intended to be used to UIView keyframe animation.
    ///
    /// - Parameter totalFrames: The total number of frames in the animation sequence.
    ///
    /// - Returns: A closure which takes the starting and ending frames for a given
    ///            set of animations, and a closure with the animations themselves,
    ///            to compute the relative start and relative duration, then
    ///            add the animations to the current animation context.

    @objc static func keyframeAnimator(totalFrames: Double) -> ((Double, Double, @escaping () -> Void) -> Void) {
        let animateFrames: (Double, Double, @escaping () -> Void) -> Void = { start, end, animations in
            UIView.addKeyframe(withRelativeStartTime: start / totalFrames,
                               relativeDuration: (end - start) / totalFrames,
                               animations: animations)
        }
        return animateFrames
    }

    /// Animate the size of the view to its full size, with a pop.
    ///
    /// This is intended to be called to bring the view into a scene,
    /// after the view has been hidden using `shrinkToInvisible()`.
    ///
    /// - Parameter duration: The intended duration (seconds) of the animation.
    /// - Parameter delay: The delay (seconds) before this animation is to begin.

    @objc func animateToFullSizeWithPop(duration: TimeInterval, delay: TimeInterval, then completion: (() -> Void)? = nil) {

        let maxScale: CGFloat = 1.25
        let normalScale: CGFloat = 1.0
        UIView.animate(withDuration: (0.7 * duration), delay: delay, options: [],
                       animations: {
                        self.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
        },
                       completion: { _ in
                        UIView.animate(withDuration: (0.3 * duration), animations: {
                            self.transform = CGAffineTransform(scaleX: normalScale, y: normalScale)
                        },
                                       completion: { _ in
                                        completion?()
                        })
        })
    }

    // MARK: - Accessibility

    /// A convenience function to set the accessibility info on a view.
    ///
    /// Only the label parameter is required. isAccessibilityElement will always be set to true.
    /// If no traits are provided, the default is to treat this view as an image.
    ///
    /// - Parameter label: a localized string which will be used as the assessibilityLabel
    /// - Parameter traits: a sequence of traits which describe the role of this view

    @objc func makeAccessible(label: String, traits: UIAccessibilityTraits = [.image]) {

        self.isAccessibilityElement = true
        self.accessibilityLabel = label
        self.accessibilityTraits = traits
    }

    // MARK: - Transforms

    /// A convenience method used to hide the view, before introducing it
    /// into a scene using `animateToFullSizeWithPop(duration:delay:)`.

    @objc func shrinkToInvisible() {

        let zeroScale: CGFloat = 0.0
        self.transform = CGAffineTransform(scaleX: zeroScale, y: zeroScale)
    }

    /// A convenience method used to scale the view by the same amount in
    /// both the x and y axes.
    ///
    /// - Parameter factor: the scaling factor to be used, from 0.0 to 1.0

    @objc func scale(by factor: CGFloat) {

        self.transform = self.transform.scaledBy(x: factor, y: factor)
    }

    /// A convenience method used to translate the view by the specified points.
    ///
    /// - Parameter xOffset: a positive or negative offset for the x axis
    /// - Parameter yOffset: a positive or negative offset for the y axis

    @objc func translate(xOffset: CGFloat = 0, yOffset: CGFloat = 0) {

        self.transform = self.transform.translatedBy(x: xOffset, y: yOffset)
    }

    /// A convenience method used to rotate the view by the specified number of degrees.
    ///
    /// - Parameter degrees: a positive or negative number of degrees

    @objc func rotate(degrees: CGFloat) {

        let radians = Measurement(value: Double(degrees), unit: UnitAngle.degrees)
                      .converted(to: .radians)
                      .value

        self.transform = self.transform.rotated(by: CGFloat(radians))
    }

    /// A convenience function to set the anchor point for a view's transform operations.
    ///
    /// - Parameter anchorPoint: in unit coordinate space (0.0, 0.0) to (1.0, 1.0)

    @objc func setAnchorPoint(_ anchorPoint: CGPoint) {

        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x,
                               y: self.bounds.size.height * anchorPoint.y)

        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x,
                               y: self.bounds.size.height * self.layer.anchorPoint.y)

        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)

        var position = self.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        self.layer.position = position
        self.layer.anchorPoint = anchorPoint
    }
}

