//
//  HoleView.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(HoleView)
public class HoleView: UIView {

    public var fillColor: UIColor = .black {
        didSet {
            shapeLayer?.fillColor = fillColor.cgColor
        }
    }

    // MARK:-

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        inscribeOval()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        inscribeOval()
    }

    // MARK:- Private

    private var shapeLayer: CAShapeLayer?

    private func inscribeOval() {

        let oval = CAShapeLayer()
        oval.path = UIBezierPath(ovalIn: self.bounds).cgPath
        oval.fillColor = fillColor.cgColor

        self.layer.addSublayer(oval)
        shapeLayer = oval
    }

}
