//
//  GridView.swift
//  PlaygroundArea
//
//  Created by Luke Durrant on 17/02/2017.
//  Copyright © 2017 Squidee. All rights reserved.
//

import UIKit

public class GridPaperView : UIView {
    
    public var shouldDrawMainLines: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var shouldDrawCenterLines: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var gridStrideSize: CGFloat = 15.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var majorGridColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var minorGridColor: UIColor = .blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var gridLineWidth: CGFloat = 0.2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        self.contentMode = .redraw
        self.backgroundColor = .clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        //This is if we're loading from a nib we don't need this lets not implement it
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        
        
        if self.shouldDrawMainLines {
            //Split this up so we could technically just draw a corner if needed
            drawGridLinesFor(axis: .x, direction: .back, dirtyRect: rect)
            drawGridLinesFor(axis: .x, direction: .forward, dirtyRect: rect)
            
            drawGridLinesFor(axis: .y, direction: .back, dirtyRect: rect)
            drawGridLinesFor(axis: .y, direction: .forward, dirtyRect: rect)
        }
        
        if self.shouldDrawCenterLines {
            self.drawMiddleLines(dirtyRect: rect)
        }
        
    }
    
    private func drawMiddleLines(dirtyRect: CGRect) {
        majorGridColor.set()
        
        //Draw X line
        let bezierPathX = UIBezierPath()
        bezierPathX.move(to: CGPoint(x: dirtyRect.midX, y: 0))
        bezierPathX.addLine(to: CGPoint(x: dirtyRect.midX, y: dirtyRect.maxY))
        
        bezierPathX.lineWidth = (self.gridLineWidth * 2)
        bezierPathX.stroke()
        
        
        let bezierPathY = UIBezierPath()
        bezierPathY.move(to: CGPoint(x: 0, y: dirtyRect.midY))
        bezierPathY.addLine(to: CGPoint(x: dirtyRect.maxX, y: dirtyRect.midY))
        
        bezierPathY.lineWidth = (self.gridLineWidth * 2)
        bezierPathY.stroke()
    }
    
    private func drawGridLinesFor(axis: Axis, direction: Direction, dirtyRect: CGRect) {
    
        var currentPoint: CGFloat = 0.0
        var keepGoing = true
        var iteration = 0
        
        self.minorGridColor.set()
        
        while (keepGoing) {
            let x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat
            switch axis {
            case .x:
                x1 = dirtyRect.midX + (CGFloat(iteration) * self.gridStrideSize)
                y1 = 0
                x2 = x1
                y2 = dirtyRect.maxY
                currentPoint += self.gridStrideSize
                break
                
            case .y:
                x1 = 0
                y1 = dirtyRect.midY + (CGFloat(iteration) * self.gridStrideSize)
                x2 = dirtyRect.maxX
                y2 = y1
                currentPoint += self.gridStrideSize
                break
            }
            
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: x1, y: y1))
            bezierPath.addLine(to: CGPoint(x: x2, y: y2))
            
            bezierPath.lineWidth = self.gridLineWidth
            bezierPath.stroke()
            
            if direction == .back {
                iteration -= 1
            } else {
                iteration += 1
            }
            
            switch axis {
            case .x:
                keepGoing = currentPoint <= (dirtyRect.maxX)
                break
                
            case .y:
                keepGoing = currentPoint <= (dirtyRect.maxY)
                break
            }
        }
        
    }
    
    private enum Axis {
        case x
        case y
    }
    
    private enum Direction {
        case back
        case forward
    }
}
