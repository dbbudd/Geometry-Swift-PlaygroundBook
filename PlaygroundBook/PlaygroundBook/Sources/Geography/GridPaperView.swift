//
//  GridView.swift
//  PlaygroundArea
//
//  Created by Luke Durrant on 17/02/2017.
//  Copyright © 2017 Squidee. All rights reserved.
//

import UIKit
import SpriteKit

public class GridPaperView : UIView {
    
    let xAxisLabel = GridPaperView.axisFactory(text: "X-Axis")
    let yAxisLabel = GridPaperView.axisFactory(text: "Y-Axis")
    
    let scene = CanvasScene()
    
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
    
    public var gridStrideSize: CGFloat = 20.0 {
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
        self.backgroundColor = .white //change to .clear
        
        self.scene.scaleMode = .resizeFill
        self.scene.backgroundColor = .clear
        self.scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let viewSK: SKView = SKView()
        viewSK.allowsTransparency = true
        viewSK.backgroundColor = .clear
        viewSK.presentScene(scene)
        
        self.addSubview(viewSK)
        
        viewSK.bindFrameToSuperviewBounds()
        
        self.scene.addChild(self.xAxisLabel)
        self.scene.addChild(self.yAxisLabel)
    }
    
    public func add(_ pen: Pen){
        self.scene.addChild(ShapeSK(pen:pen).node)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        //This is if we're loading from a nib we don't need this lets not implement it
        fatalError("init(coder:) has not been implemented")
    }
    
    public func toggleAxisLabels() {
        self.xAxisLabel.isHidden = !self.xAxisLabel.isHidden
        self.yAxisLabel.isHidden = !self.yAxisLabel.isHidden
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
        
        self.xAxisLabel.position = CGPoint(x: (rect.midX - 30), y: -15)
        self.yAxisLabel.position = CGPoint(x: -30, y: (rect.midY - 20))
    }
    
    private func drawMiddleLines(dirtyRect: CGRect) {
        majorGridColor.set()
        
        //Draw X line
        let bezierPathX = UIBezierPath()
        bezierPathX.move(to: CGPoint(x: dirtyRect.midX, y: 0))
        bezierPathX.addLine(to: CGPoint(x: dirtyRect.midX, y: dirtyRect.maxY))
        
        bezierPathX.lineWidth = (self.gridLineWidth * 2)
        bezierPathX.stroke()
        
        //Draw Y line
        let bezierPathY = UIBezierPath()
        bezierPathY.move(to: CGPoint(x: 0, y: dirtyRect.midY))
        bezierPathY.addLine(to: CGPoint(x: dirtyRect.maxX, y: dirtyRect.midY))
        
        bezierPathY.lineWidth = (self.gridLineWidth * 2)
        bezierPathY.stroke()
    }
    
    //THis should probably be in another file in the real world called something like SKLabelNodeFactory but because we're only in playground its probably ok
    private static func axisFactory(text: String) -> SKLabelNode {
        
        //label for axis
        let label: SKLabelNode = SKLabelNode(fontNamed: "AvenirNext")
        label.text = text
        label.fontSize = 14.0
        label.fontColor = .gray
        label.zPosition = -999
        
        return label
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
