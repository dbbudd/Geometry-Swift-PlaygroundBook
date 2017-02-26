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

extension UIView {
    
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
    let scene: CanvasScene = CanvasScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.gridPaper.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.gridPaper)
        self.gridPaper.bindFrameToSuperviewBounds()
        
        let scene: CanvasScene = CanvasScene()
        scene.backgroundColor = .clear
        let viewSK: SKView = SKView()
        viewSK.allowsTransparency = true
        viewSK.backgroundColor = .clear
        viewSK.presentScene(scene)
        
        self.view.addSubview(viewSK)
        viewSK.bindFrameToSuperviewBounds()
        
        var p:Pen = Pen()
        
        p.addLine(distance: 200)
        
        // Add our path to the canvas
        addShape(pen:p)

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
    
    private func addShape(pen: Pen){
        self.scene.addChild(ShapeSK(pen:pen).node)
    }
}
