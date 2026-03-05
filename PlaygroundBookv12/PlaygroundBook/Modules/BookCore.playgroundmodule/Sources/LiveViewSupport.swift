//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
import PlaygroundSupport

/// Instantiates a new instance of a live view.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.
public func instantiateLiveView() -> PlaygroundLiveViewable {
    let candidateBundles: [Bundle] = [
        Bundle.main,
        Bundle(for: LiveViewController.self)
    ]

    guard let storyboardBundle = candidateBundles.first(where: {
        $0.path(forResource: "LiveView", ofType: "storyboardc") != nil
    }) else {
        // LiveViewTestApp can run without copied storyboard resources.
        return LiveViewController()
    }

    let storyboard = UIStoryboard(name: "LiveView", bundle: storyboardBundle)

    guard let viewController = storyboard.instantiateInitialViewController() else {
        fatalError("LiveView.storyboard does not have an initial scene; please set one or update this function")
    }

    guard let liveViewController = viewController as? LiveViewController else {
        fatalError("LiveView.storyboard's initial scene is not a LiveViewController; please either update the storyboard or this function")
    }

    return liveViewController
}
