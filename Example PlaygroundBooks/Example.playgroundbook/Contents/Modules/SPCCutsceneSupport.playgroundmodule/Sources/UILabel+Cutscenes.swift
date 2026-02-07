//
//  UILabel+Cutscenes.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

public extension UILabel {

    func setAttributedText(xmlAnnotatedString: String) {

        var style = CutsceneAttributedStringStyle()
        style.fontSize = self.font.pointSize

        self.attributedText = NSAttributedString(textXML: xmlAnnotatedString, style: style)
    }
    
    /// A convenience function to enable resizing of styled text.
    ///
    /// This function is needed because UILabel will not automatically resize your attributed text if you have set a font attribute.
    ///
    /// - Parameter unstyledFont: the font to use for ranges where no other font has been applied.

    func resizeAttributedText(unstyledFont: UIFont) {

        guard let attrText = self.attributedText else { return }

        let textRect: (UILabel) -> CGRect = { (label) in
            return label.textRect(forBounds: label.bounds, limitedToNumberOfLines: 0)
        }

        var fontSize = self.font.pointSize
        let mutable = NSMutableAttributedString(attributedString: attrText)

        while !self.bounds.contains(textRect(self)) {
            mutable.enumerateAttribute(.font, in: NSMakeRange(0, mutable.length), options: []) { (value, range, stop) in
                if let theFont = value as? UIFont {
                    fontSize = theFont.pointSize - 2
                    let newFont = UIFont(descriptor: theFont.fontDescriptor, size: fontSize)
                    mutable.setAttributes([.font : newFont], range: range)
                }
            }
            self.font = UIFont(descriptor: unstyledFont.fontDescriptor, size: fontSize)
            self.attributedText = mutable
        }
    }
}
