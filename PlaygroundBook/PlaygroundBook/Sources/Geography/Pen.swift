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
    
    public func currentPosition() -> CGPoint{
        let position = self.path.currentPoint
        
        return position
    }
    
    public func drawCircle(radius: CGFloat){
        self.path.addArc(withCenter: self.path.currentPoint, radius: radius, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
    }
    
    //Function enabling us to use drawArc() by Anders Randler
    public mutating func addArc(radius: Double, angle: Double){
        let currentX = Double(self.path.currentPoint.x)
        let currentY = Double(self.path.currentPoint.y)
        if angle < 0 {
            let toCenterInRadians = (90 - currentHeading) * (.pi / 180)
            let dx = radius * cos(toCenterInRadians)
            let dy = -radius * sin(toCenterInRadians)
            let centerX = currentX + dx
            let centerY = currentY + dy
            let startAngle = (90 + currentHeading) * (.pi / 180)
            let endAngle = (90 + currentHeading + angle) * (.pi / 180)
            currentHeading += angle
            self.path.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)
        } else {
            let toCenterInRadians = (90 + currentHeading) * (.pi / 180)
            let dx = radius * cos(toCenterInRadians)
            let dy = radius * sin(toCenterInRadians)
            let centerX = currentX + dx
            let centerY = currentY + dy
            let startAngle = (-90 + currentHeading) * (.pi / 180)
            let endAngle = (-90 + currentHeading + angle) * (.pi / 180)
            currentHeading += angle
            self.path.addArc(withCenter: CGPoint(x: centerX, y: centerY), radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        }
    }
    
}


