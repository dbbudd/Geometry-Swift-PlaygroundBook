//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  A source file which is part of the auxiliary module named "BookCore".
//  Provides the implementation of the "always-on" live view.
//

import UIKit
import PlaygroundSupport

@objc(BookCore_LiveViewController)
public class LiveViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    
    let gridPaper = GridPaperView()

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.gridPaper.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.gridPaper)
        self.gridPaper.bindFrameToSuperviewBounds()
    }

    public func add(_ pen: Pen){
        self.gridPaper.scene.addChild(ShapeSK(pen:pen).node)
    }
    /*
    public func liveViewMessageConnectionOpened() {
        // Implement this method to be notified when the live view message connection is opened.
        // The connection will be opened when the process running Contents.swift starts running and listening for messages.
    }
    */

    /*
    public func liveViewMessageConnectionClosed() {
        // Implement this method to be notified when the live view message connection is closed.
        // The connection will be closed when the process running Contents.swift exits and is no longer listening for messages.
        // This happens when the user's code naturally finishes running, if the user presses Stop, or if there is a crash.
    }
    */

    public func receive(_ message: PlaygroundValue) {
        // Implement this method to receive messages sent from the process running Contents.swift.
        // This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
        // Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
    }
}
