//
//  GridScene.swift
//  Geometry
//
//  Created by Daniel Budd on 24/08/2016.
//  Copyright © 2016 Daniel Budd. All rights reserved.
//

import SpriteKit

public class GridScene : SKScene {
    public var canvas = SKSpriteNode(imageNamed: "bgGrid_light")
    
    override public func didMove(to view: SKView) {
        super.didMove(to: view)
        canvas.position = CGPoint(x:frame.size.width/2, y:frame.size.height/2)
        //canvas.size = CGSize(width:2048, height:1536)
        canvas.size = CGSize(width: frame.size.width, height: frame.size.height)
        self.addChild(canvas)
    }
    
    override public func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
    
    func addPen(pen: Pen){
        self.addChild(Shape(pen:pen).node)
    }
}
