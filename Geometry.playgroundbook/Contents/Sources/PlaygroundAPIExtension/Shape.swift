//
//  Shape.swift
//  Geometry
//
//  Created by Daniel Budd on 24/08/2016.
//  Copyright © 2016 Daniel Budd. All rights reserved.
//
import SpriteKit

public struct ShapeSK {
    public let node = SKShapeNode()
    
    public init(pen: Pen){
        self.node.path = pen.path.cgPath
        self.node.position = pen.position
        self.node.fillColor = pen.fillColor
        self.node.strokeColor = pen.penColor
        self.node.lineWidth = pen.lineWidth
    }
}
