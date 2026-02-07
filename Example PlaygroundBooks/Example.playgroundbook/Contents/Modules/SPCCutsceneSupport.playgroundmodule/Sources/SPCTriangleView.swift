//
//  SPCTriangleView.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

/// This view is masked into the shape of a triangle.
///
/// Set the `backgroundColor` to use as a graphical element in a scene.

@objc(SPCTriangleView)
public class SPCTriangleView : UIView {

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        inscribeTriangle()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        inscribeTriangle()
    }

    // MARK:- Private

    private func inscribeTriangle() {

        let triangle = CAShapeLayer()
        let path = UIBezierPath()

        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.minY))
        path.close()

        triangle.path = path.cgPath
        triangle.fillColor = UIColor.black.cgColor

        self.layer.mask = triangle
    }
}
