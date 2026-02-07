//
//  UIImage+Cutscenes.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

public extension UIImage {
    
    func scaledToFit(within availableSize: CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero

        let aspectWidth = availableSize.width / self.size.width
        let aspectHeight = availableSize.height / self.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio

        let rendererFormat = UIGraphicsImageRendererFormat.preferred()

        let renderer = UIGraphicsImageRenderer(size: scaledImageRect.size, format: rendererFormat)
        let scaledImage = renderer.image { _ in
            self.draw(in: scaledImageRect)
        }
        return scaledImage
    }
}
