//
//  SceneViewController.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(SceneViewController)
open class SceneViewController: UIViewController {

    /// Indicates whether or not this scene should fade in.
    public var shouldFadeIn: Bool = true

    /// The duration of the fade in animation for this scene.
    public var durationFadeIn: TimeInterval = 0.3

    /// Indicates whether or not this scene should fade out.
    public var shouldFadeOut: Bool = true

    /// The duration of the fade out animation for this scene.
    public var durationFadeOut: TimeInterval = 0.3

    // MARK:- View Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Ensure that animations do not appear outside the intended area.
        self.view.clipsToBounds = true
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.layoutIfNeeded()
    }

    // MARK:- Animation

    /// Animates a change to the specified constraint with a bounce effect.
    ///
    /// - parameter constraint: The constraint to modify
    /// - parameter value: The target value of the constraint's constant
    /// - parameter bounce: The number of points to overshoot the target value, before settling back to the target value
    /// - parameter duration: The number of seconds to animate the change
    /// - parameter delay: The number of seconds to wait before starting this animation
    /// - parameter completion: This block will be run after the animation has completed.

    public func animateChange(to constraint: NSLayoutConstraint, value: CGFloat, bounce: CGFloat = 18.0, duration: TimeInterval, delay: TimeInterval, then completion: (() -> Void)? = nil) {

        let overshoot = (value < constraint.constant) ? -bounce : bounce

        UIView.animate(withDuration: (0.7 * duration), delay: delay, options: [],
                       animations: {
                        constraint.constant = value + overshoot
                        self.view.layoutIfNeeded()
        },
                       completion: { _ in
                        UIView.animate(withDuration: (0.3 * duration),
                                       animations: {
                            constraint.constant = value
                            self.view.layoutIfNeeded()
                        },
                                       completion: { _ in
                                        completion?()
                        })
        })
    }

    /// Called when all animations in a given scene have completed.
    ///
    /// Signals other components that the animations have completed.

    public func animationsDidComplete() {

        NotificationCenter.default.post(name: .CutsceneAnimationDidComplete, object: self)
    }

    // MARK:- Utility

    /// This function provides a concise way to setup a constraint linking two layout anchors.
    ///
    /// - parameter first: This layout anchor will be used to create a constraint.
    /// - parameter second: This layout anchor will be used to create a constraint.
    /// - parameter removing: This existing constraint will be removed. Must be a constraint on the calling instance's .view
    ///
    /// - returns: A constraint connecting the two anchors with an `equals` relationship.

    public func link<T>(_ first: NSLayoutAnchor<T>, to second: NSLayoutAnchor<T>, removing existing: NSLayoutConstraint) -> NSLayoutConstraint {

        self.view.removeConstraint(existing)

        let constraint = first.constraint(equalTo: second)
        constraint.isActive = true

        return constraint
    }
}
