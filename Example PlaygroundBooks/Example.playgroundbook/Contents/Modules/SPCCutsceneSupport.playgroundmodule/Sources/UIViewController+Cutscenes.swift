//
//  UIViewController+Cutscenes.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

public extension UIViewController {

    /// A convenience function to embed a child controller, using layout constraints.
    ///
    /// - Parameter vc: the controller to embed.
    /// - Parameter below: a view from the parent controller's view hierarchy.

    func embedChildController(_ vc: UIViewController, below: UIView? = nil) {

        addChild(vc)

        vc.view.translatesAutoresizingMaskIntoConstraints = false

        if let otherView = below {
            view.insertSubview(vc.view, belowSubview: otherView)
        } else {
            view.addSubview(vc.view)
        }

        NSLayoutConstraint.activate([
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.topAnchor.constraint(equalTo: view.topAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        vc.view.setNeedsLayout()
        vc.view.layoutIfNeeded()

        vc.didMove(toParent: self)
    }
}
