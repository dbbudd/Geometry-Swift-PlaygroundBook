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
    public var penColor = UIColor()
    public var fillColor = UIColor()
    public var lineWidth = CGFloat()
    public var currentHeading: Double = 0.0
    public var position = CGPoint()
    
    public init(){
        self.position = CGPoint(x:0, y:0)
        self.path.move(to: position)
        self.penColor = UIColor.blue
        self.fillColor = UIColor.clear
        self.lineWidth = 3.0
    }
    
    public func addLine(distance: Double){
        
        let headingInRadians = self.currentHeading * (3.14159 / 180) //convert to radians
        let dx = distance * cos(headingInRadians)
        let dy = distance * sin(headingInRadians)
        let currentX = Double(self.path.currentPoint.x)
        let currentY = Double(self.path.currentPoint.y)
        
        self.path.addLine(to: CGPoint(x: currentX + dx, y: currentY + dy))
        self.path.stroke()
    }
    
    public func move(distance: Double){
        let headingInRadians = self.currentHeading * (3.14159 / 180) //convert to radians
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


