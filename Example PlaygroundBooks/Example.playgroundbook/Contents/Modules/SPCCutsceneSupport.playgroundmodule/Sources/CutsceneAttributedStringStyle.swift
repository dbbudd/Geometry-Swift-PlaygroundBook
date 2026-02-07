//
//  CutsceneAttributedStringStyle.swift
//  
//  Copyright © 2016-2020 Apple Inc. All rights reserved.
//

import UIKit

// Colors added for Dark Mode support
public extension UIColor {
    
    static var mainTextColorLT: UIColor {
        return UIColor(named: "defaultText") ?? UILabel(frame: .zero).textColor
    }
    
    static var codeVoiceLT: UIColor {
        return UIColor(named: "defaultText") ?? UILabel(frame: .zero).textColor
    }
}

public struct CutsceneAttributedStringStyle: AttributedStringStyle {
    
    public init() { }
    
    private var paragraphStyle: NSMutableParagraphStyle {
        let ps = NSMutableParagraphStyle()
        ps.lineHeightMultiple = 1.0
        ps.alignment = .center
        return ps
    }
    
    private var baseDescriptor: UIFontDescriptor {
        return UIFont.systemFont(ofSize: fontSize, weight: .regular).fontDescriptor
    }

    private var textAttributes: [NSAttributedString.Key: Any] {
        let descriptor = baseDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.light]
        ])
        let font = UIFont(descriptor: descriptor, size: fontSize)
        return [
            .font : font,
            .foregroundColor : color,
            .paragraphStyle : paragraphStyle
        ]
    }
    
    private var codeDescriptor: UIFontDescriptor {
        return (UIFont(name: "SFMono-Regular", size: fontSize) ?? UIFont(name: "Menlo", size: fontSize)!).fontDescriptor
    }
    
    private var codeVoiceAttributes: [NSAttributedString.Key: Any] {
        let descriptor = codeDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.bold]
        ])
        return [
            .font : UIFont(descriptor: descriptor, size: fontSize),
            .foregroundColor : color,
            .paragraphStyle : paragraphStyle
        ]
    }
    
    private var boldAttributes: [NSAttributedString.Key: Any] {
        let boldDescriptor = baseDescriptor.addingAttributes([
            UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : UIFont.Weight.medium]
        ])
        return [
            .font : UIFont(descriptor: boldDescriptor, size: fontSize)
        ]
    }
    
    private var italicAttributes: [NSAttributedString.Key: Any] {
        guard let font = textAttributes[.font] as? UIFont,
            let italicDescriptor = font.fontDescriptor.withSymbolicTraits(.traitItalic) else { return [:] }
        return [
            .font : UIFont(descriptor: italicDescriptor, size: fontSize)
        ]
    }
    
    private var linkAttributes: [NSAttributedString.Key: Any] {
        return [
            .foregroundColor : UIView().tintColor ?? UIColor.red,
            AttributedStringStyler.Key.linkAttribute : "href"
        ]
    }
    
    private var rightAlignedAttributes: [NSAttributedString.Key: Any] {
        let ps = paragraphStyle
        ps.alignment = .right
        return [
            .paragraphStyle : ps
        ]
    }
    
    private var centerAlignedAttributes: [NSAttributedString.Key: Any] {
        let ps = paragraphStyle
        ps.alignment = .center
        return [
            .paragraphStyle : ps
        ]
    }
    
    private var strikethroughAttributes: [NSAttributedString.Key: Any] {
        return [
            .strikethroughStyle : NSUnderlineStyle.single.rawValue
        ]
    }
    
    // MARK: Public
    
    public static var shared: AttributedStringStyle = CutsceneAttributedStringStyle()
    
    public var fontSize: CGFloat = 34.0
    
    public var color: UIColor = UIColor.mainTextColorLT

    public var attributes: [String : [NSAttributedString.Key: Any]] {
        return [
            "text" : textAttributes,
            "cv" : codeVoiceAttributes,
            "a" : linkAttributes,
            "b" : boldAttributes,
            "i": italicAttributes,
            "right": rightAlignedAttributes,
            "center": centerAlignedAttributes,
            "st": strikethroughAttributes
        ]
    }
}
