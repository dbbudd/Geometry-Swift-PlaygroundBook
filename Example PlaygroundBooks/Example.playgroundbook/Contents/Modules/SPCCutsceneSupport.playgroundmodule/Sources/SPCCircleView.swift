//
//  SPCCircleView.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

/// This view is masked into the shape of a circle.
///
/// Set the `backgroundColor` to use as a graphical element in a scene.

@objc(SPCCircleView)
public class SPCCircleView: UIView {

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        inscribeOval()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        inscribeOval()
    }

    // MARK:- Private

    private func inscribeOval() {

        let oval = CAShapeLayer()
        oval.path = UIBezierPath(ovalIn: self.bounds).cgPath
        oval.fillColor = UIColor.black.cgColor

        self.layer.mask = oval
    }

}
