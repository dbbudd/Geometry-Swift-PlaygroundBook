//
//  GridViewController.swift
//  PlaygroundArea
//
//  Created by Luke Durrant on 17/2/17.
//  Copyright © 2017 Squidee. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

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

class GridViewController: UIViewController {
    
    let gridPaper = GridPaperView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.gridPaper.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.gridPaper)
        self.gridPaper.bindFrameToSuperviewBounds()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public func add(_ pen: Pen){
        self.gridPaper.scene.addChild(ShapeSK(pen:pen).node)
    }
}
