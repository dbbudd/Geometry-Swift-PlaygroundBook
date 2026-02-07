//
//  AttributedStringStyler.swift
//  
//  Copyright © 2016-2020 Apple Inc. All rights reserved.
//

import UIKit

public protocol AttributedStringStyle {
    static var shared: AttributedStringStyle { get }
    var fontSize: CGFloat { get set }
    var color: UIColor { get set }
    var attributes: [String : [NSAttributedString.Key: Any]] { get }
}

public class AttributedStringStyler {
    public struct Key {
        // Name of the attribute
        static let linkAttribute = NSAttributedString.Key(rawValue: "link-attribute")
        static let linkScheme = NSAttributedString.Key(rawValue: "link-scheme")
    }
    
    private var elementStyleAttributes: [String : [NSAttributedString.Key: Any]] = [:]
    private var styleAttributesStack: [[NSAttributedString.Key: Any]] = []
    
    private var currentStyleAttributes: [NSAttributedString.Key: Any] = [:]
    
    let attributedString = NSMutableAttributedString()

    /// Creates an instance of the string styler from a chunk of well-formed XML, and applies the specified style attributes to each element.
    ///
    /// - Parameter xml: The xml to be styled.
    /// - Parameter styleAttributes: A dictionary of styles keyed on element name.
    ///
    public init(xml: String, style: AttributedStringStyle) {
        elementStyleAttributes = style.attributes
        let parser = SlimXMLParser(xml: xml)
        parser.delegate = self
        parser.parse()
    }
    
    // Merges all the style attributes in the stack working up from the bottom.
    // The result (currentStyleAttributes) is the style to be applied to any text.
    func updateCurrentStyleAttributes() {
        currentStyleAttributes = [:]
        for attributes in styleAttributesStack {
            currentStyleAttributes = currentStyleAttributes.merging(attributes, uniquingKeysWith: { (_, new) in new })
        }
    }
    
}

extension AttributedStringStyler: SlimXMLParserDelegate {
    
    func parser(_ parser: SlimXMLParser, didStartElement  element: SlimXMLElement) {
        
        if var styleAttributes = elementStyleAttributes[element.name] {
            // Attach link attributes.
            if let linkAttribute = styleAttributes[AttributedStringStyler.Key.linkAttribute] as? String, let href = element.attributes[linkAttribute] {
                styleAttributes[.link] = href
            }
            if let colorAttribute = element.attributes["color"] {
                let color = UIColor(delimitedList: colorAttribute)
                styleAttributes[.foregroundColor] = color
            }
            styleAttributesStack.append(styleAttributes)
            updateCurrentStyleAttributes()
        }
    }
    
    func parser(_ parser: SlimXMLParser, didEndElement  element: SlimXMLElement) {

        if element.name == "br" {
            // Insert a line break.
            attributedString.append(NSAttributedString(string: "\n", attributes: currentStyleAttributes))
        } else if element.name == "p" {
            // Insert a paragraph break.
            attributedString.append(NSAttributedString(string: "\n\r", attributes: currentStyleAttributes))
        }
        
        // Only pop style if it was pushed onto the stack in didStartElement.
        if let _ = elementStyleAttributes[element.name] {
            _ = styleAttributesStack.popLast()
            updateCurrentStyleAttributes()
        }
    }
    
    func parser(_ parser: SlimXMLParser, foundCharacters string: String) {
        attributedString.append(NSAttributedString(string: string, attributes: currentStyleAttributes))
    }
    
    func parser(_ parser: SlimXMLParser, shouldCaptureElementContent elementName: String, attributes: [String : String]) -> Bool {
        return false
    }
    
    func parser(_ parser: SlimXMLParser, shouldLocalizeElementWithID elementName: String) -> Bool {
        return false
    }
    
    func parser(_ parser: SlimXMLParser, parseErrorOccurred parseError: Error, lineNumber: Int) {
        NSLog("\(parseError.localizedDescription) at line: \(lineNumber)")
    }
}

extension NSAttributedString {
    
    // Generates an attributed string by applying style to a chunk of well-formed XML.
    // Assumes the `text` style i.e. that the chunk of xml should be wrapped in a `<text>` element.
    public convenience init(textXML: String, style: AttributedStringStyle) {
        let trimmedText = textXML.trimmingCharacters(in: .whitespacesAndNewlines)
        self.init(xml: "<text>\(trimmedText)</text>", style: style)
    }

    // Generates an attributed string by applying style to a chunk of well-formed XML.
    public convenience init(xml: String, style: AttributedStringStyle, preProcessXML: Bool = true) {

        // Style the xml to an attributed string.
        let attributedText = AttributedStringStyler(xml: xml, style: style).attributedString
        
        self.init(attributedString: attributedText)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        self.init(red: CGFloat(min(red, 255)) / 255.0,
                  green: CGFloat(min(green, 255)) / 255.0,
                  blue: CGFloat(min(blue, 255)) / 255.0,
                  alpha: CGFloat(min(alpha, 255)) / 255.0)
    }
    
    // Creates a color from a delimited string like this "0.5, 0.4, 0.1, 1.0" rgba
    convenience init(delimitedList: String) {
        var validCharacters = CharacterSet.decimalDigits
        validCharacters.insert(".") // "01234567890."
        let cleanedList = delimitedList.trimmingCharacters(in: validCharacters.inverted)
        let components = cleanedList.components(separatedBy: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
        var values: [CGFloat] = [0.0, 0.0, 0.0, 0.0]
        let componentValues = components.map{ min(Float($0) ?? 0.0, 1.0) }
        for i in 0..<min(componentValues.count, values.count) {
            values[i] = CGFloat(componentValues[i])
        }
        self.init(red: values[0], green: values[1], blue: values[2], alpha: values[3])
    }
}


