//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif

/// Instantiates a new instance of a live view controller.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.
public func instantiateLiveViewController() -> LiveViewController {
    let storyboard = UIStoryboard(name: "LiveView", bundle: nil)

    guard let viewController = storyboard.instantiateInitialViewController() else {
        fatalError("LiveView.storyboard does not have an initial scene; please set one or update this function")
    }

    guard let liveViewController = viewController as? LiveViewController else {
        fatalError("LiveView.storyboard's initial scene is not a LiveViewController; please either update the storyboard or this function")
    }

    return liveViewController
}

#if canImport(PlaygroundSupport)
/// Instantiates a new instance of a live view for Swift Playgrounds.
public func instantiateLiveView() -> PlaygroundLiveViewable {
    instantiateLiveViewController()
}
#endif
