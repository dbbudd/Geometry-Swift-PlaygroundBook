//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Instantiates a live view and passes it to the PlaygroundSupport framework.
//

import UIKit
import BookCore
#if canImport(PlaygroundSupport) && !(arch(arm64) && targetEnvironment(simulator))
import PlaygroundSupport
#endif

// Instantiate a new instance of the live view from BookCore and pass it to PlaygroundSupport.
#if canImport(PlaygroundSupport) && !(arch(arm64) && targetEnvironment(simulator))
PlaygroundPage.current.liveView = instantiateLiveView()
#endif
