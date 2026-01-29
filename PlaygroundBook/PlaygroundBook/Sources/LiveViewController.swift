//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  An auxiliary source file which is part of the book-level auxiliary sources.
//  Provides the implementation of the "always-on" live view.
//

import UIKit
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif

//CODE IN HERE BECOMES CONTENT.SWIFT IN THE BOOK

public extension UIView {

    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }

}

@objc(Book_Sources_LiveViewController)
public class LiveViewController: UIViewController {

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

    #if canImport(PlaygroundSupport)
    public func receive(_ message: PlaygroundValue) {
        // Implement this method to receive messages sent from the process running Contents.swift.
        // This method is *required* by the PlaygroundLiveViewMessageHandler protocol.
        // Use this method to decode any messages sent as PlaygroundValue values and respond accordingly.
    }
    #endif
}

#if canImport(PlaygroundSupport)
extension LiveViewController: PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {}
#endif
