//
//  Pen.swift
//  Geometry
//
//  Created by Daniel Budd on 24/08/2016.
//  Copyright © 2016 Daniel Budd. All rights reserved.
//

import SpriteKit

public struct Pen {
    public var path = UIBezierPath()
    public var penColor = UIColor.blue
    public var fillColor = UIColor.clear
    public var lineWidth: CGFloat = 3.0
    public var currentHeading: Double = 0.0
    
    public var position = CGPoint(x:0, y:0) {
        didSet {
            self.path.move(to: self.position)
        }
    }
    
    public init(){
        defer {
            self.position = CGPoint(x: 0, y: 0)
        }
    }

    public func addLine(distance: Double){
        
        let headingInRadians = self.currentHeading * (Double.pi / 180) //convert to radians
        let dx = distance * cos(headingInRadians)
        let dy = distance * sin(headingInRadians)
        let currentX = Double(self.path.currentPoint.x)
        let currentY = Double(self.path.currentPoint.y)
        
        self.path.addLine(to: CGPoint(x: currentX + dx, y: currentY + dy))
        self.path.stroke()
    }
    
    public func move(distance: Double){
        let headingInRadians = self.currentHeading * (Double.pi / 180) //convert to radians
        let dx = distance * cos(headingInRadians)
        let dy = distance * sin(headingInRadians)
        let currentX = Double(self.path.currentPoint.x)
        let currentY = Double(self.path.currentPoint.y)
        
        self.path.move(to: CGPoint(x: currentX + dx, y: currentY + dy))
        self.path.stroke()
    }
    
    public func goto(dx: Double, dy: Double){
        let currentX = Double(self.path.currentPoint.x)
        let currentY = Double(self.path.currentPoint.y)
        
        self.path.move(to: CGPoint(x: currentX + dx, y: currentY + dy))
        self.path.stroke()
    }
    
    public func drawTo(dx: Double, dy: Double){
        let currentX = Double(self.path.currentPoint.x)
        let currentY = Double(self.path.currentPoint.y)
        
        self.path.addLine(to: CGPoint(x: currentX + dx, y: currentY + dy))
        self.path.stroke()
    }
    
    public mutating func turn(degrees: Double){
        self.currentHeading = self.currentHeading + degrees
    }
}


