//
//  CGAffineTransform+Cutscenes.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

public extension CGAffineTransform {
    
    var rotationAngle: CGFloat {
        return atan2(b, a) * 180 / CGFloat.pi
    }

    var scaleX: CGFloat {
        return sqrt(a * a + c * c)
    }

    var scaleY: CGFloat {
        return sqrt(b * b + d * d)
    }
}
