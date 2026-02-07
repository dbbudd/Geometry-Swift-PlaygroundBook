//
//  SlimXMLParser.swift
//  
//  Copyright © 2016-2020 Apple Inc. All rights reserved.
//

import Foundation

protocol SlimXMLParserDelegate {
    func parser(_ parser: SlimXMLParser, didStartElement element: SlimXMLElement)
    func parser(_ parser: SlimXMLParser, didEndElement element: SlimXMLElement)
    func parser(_ parser: SlimXMLParser, foundCharacters string: String)
    func parser(_ parser: SlimXMLParser, shouldCaptureElementContent elementName: String, attributes: [String : String]) -> Bool
    func parser(_ parser: SlimXMLParser, shouldLocalizeElementWithID elementName: String) -> Bool
    func parser(_ parser: SlimXMLParser, parseErrorOccurred parseError: Error, lineNumber: Int)
}

public class SlimXMLElement {
    // Name of the element.
    var name: String = ""
    
    // Attributes of the element.
    var attributes = [String : String]()
    
    // Return the attributes as a string of the form: type="code", id="fPF-Kg-tG9"
    var attributesString: String {
        var result = ""
        for (attrName, attrValue) in attributes {
            result += " \(attrName)=\"\(attrValue)\""
        }
        return result
    }
    
    // True if the content of the element is captured during parsing.
    var shouldCaptureContent: Bool = false
    
    // Raw content of the element as parsed.
    // e.g. Open your <b>Photos</b> album.
    var content: String?

    // Content as plain text stripped of all XML tags, and unescaped.
    var plainContent: String? {
        guard let content = content else { return nil }
        var result = content.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        result = result.xmlUnescaped()
        return result
    }
    
    // Content as a chunk of XML wrapped inside element tags, complete with its attributes.
    // e.g. <title id="fPF-Kg-tG9">Open your <b>Photos</b> album.</title>
    // Before being wrapped in the element tags, leading and trailing newlines are stripped off the content, and any remaining whitespace is left-vertically trimmed.
    var xmlContent: String? {
       guard let content = content else { return nil }
        var attrs = ""
        for (attrName, attrValue) in attributes {
            attrs += " \(attrName)=\"\(attrValue.xmlEscaped())\""
        }
        return "<\(name)\(attrs)>\(content.linesLeftTrimmed())</\(name)>"
    }
    
    init(name: String, attributes: [String : String], shouldCaptureContent: Bool) {
        self.name = name
        self.attributes = attributes
        self.shouldCaptureContent = shouldCaptureContent
    }
}

public class SlimXMLParser: NSObject {
    private var parser: XMLParser
    private var elementStack = [SlimXMLElement]()
    
    var level = 0
    var prefix: String {
        return String(repeating: "   ", count: self.level)
    }
    
    var delegate: SlimXMLParserDelegate?
        
    public init(xml: String) {
        let xmlData = xml.data(using: String.Encoding.utf8)!
        parser = XMLParser(data: xmlData)
        super.init()
        parser.delegate = self
    }
    
    public func parse() {
        parser.parse()
    }
    
    private func shouldCaptureElementContent(_ elementName: String, attributes: [String : String]) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.parser(self, shouldCaptureElementContent: elementName, attributes: attributes)
    }

    private func shouldLocalizeElementWithID(_ elementName: String) -> Bool {
        guard let delegate = delegate else { return false }
        return delegate.parser(self, shouldLocalizeElementWithID: elementName)
    }
}


extension SlimXMLParser: XMLParserDelegate {
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
//        NSLog("\(prefix)didStartElement: \(elementName)")

        level += 1
        
        var openingTag = "<\(elementName)"
        for (attrName, attrValue) in attributeDict {
            openingTag += " \(attrName)=\"\(attrValue.xmlEscaped())\""
        }
        openingTag += ">" // e.g. <text id="GnH-Cm-yVy">
        
        // Walk up the stack and add the element opening tag to any ancestor elements that are capturing content.
        for capturingElement in elementStack.reversed().filter({ $0.shouldCaptureContent }) {
            capturingElement.content = (capturingElement.content ?? "") + openingTag
        }
        
        // Add the new element to the stack.
        let shouldCaptureContent = shouldCaptureElementContent(elementName, attributes: attributeDict)
        let element = SlimXMLElement(name: elementName, attributes: attributeDict, shouldCaptureContent: shouldCaptureContent)
        elementStack.append(element)
        
        delegate?.parser(self, didStartElement: element)
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        level -= 1
        
        var prelocalizedContent: String?
        var localizedContent: String?
        
        if let element = elementStack.popLast() {
//            NSLog("\(prefix)didEndElement: \(element.name)")
//            NSLog("\(prefix)attributes: [\(element.attributes)]")
//            NSLog("\(prefix)content: [\(element.content ?? "")]")
            
            if shouldLocalizeElementWithID(elementName), let id = element.attributes["id"] {
                prelocalizedContent = element.content
                localizedContent = Bundle.main.localizedString(forKey: id, value: element.content, table: "LearningTrail")
                element.content = localizedContent
            }
            
            delegate?.parser(self, didEndElement: element)
        }
        
        let openingTag = "<\(elementName)>" // e.g. <text>
        let closingTag = "</\(elementName)>" // e.g. </text>
        
        // Walk up the stack and append the element closing tag to any ancestor elements that are capturing content.
        // Replace content with localized content if available.
        for capturingElement in elementStack.reversed().filter({ $0.shouldCaptureContent }) {
            var capturingElementContent = capturingElement.content ?? ""
            if let prelocalizedContent = prelocalizedContent, let localizedContent = localizedContent {
                // The prelocalized content of the element that has just ended should be at the end of the capturingElement content.
                // So roll that back and substitute localizedContent instead.
                let rolledBackIndex = capturingElementContent.index(capturingElementContent.endIndex, offsetBy: -prelocalizedContent.count)
                let rolledbackContent = capturingElementContent[..<rolledBackIndex]
                capturingElementContent = rolledbackContent + localizedContent
            }
            if capturingElementContent.hasSuffix(openingTag) {
                // If ends with opening tag, replace with single self-closing tag e.g. <br/>
                let rolledBackIndex = capturingElementContent.index(capturingElementContent.endIndex, offsetBy: -openingTag.count)
                let rolledbackContent = capturingElementContent[..<rolledBackIndex]
                let selfClosingTag = "<\(elementName)/>" // e.g. <br/>
                capturingElement.content = rolledbackContent + selfClosingTag
            } else {
                capturingElement.content = capturingElementContent + closingTag
            }
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        //NSLog("\(prefix)foundCharacters: [\(string)]")
        
        // Walk up the stack and append the found characters to any elements that are capturing content..
        for capturingElement in elementStack.reversed().filter({ $0.shouldCaptureContent }) {
            capturingElement.content = (capturingElement.content ?? "") + string.xmlEscaped()
        }
        delegate?.parser(self, foundCharacters: string)
    }
    
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        delegate?.parser(self, parseErrorOccurred: parseError, lineNumber: parser.lineNumber)
    }
}

extension SlimXMLParser {
    
    /// Given an XML string, returns all the elements with the specified name, along with their attributes.
    ///
    /// - Parameters:
    ///   - xml: The xml string to be parsed.
    ///   - elementName: The name of the element to be found.
    /// - Returns: An array of tuples, one for each element found.
    ///     The tuple contains three named values: (name, content, attributes)
    ///     name : the name of the element
    ///     content : the content of the element
    ///     attributes : the attributes of the element
    ///
    public class func getElementsIn(xml: String, named elementName: String, localized: Bool = false) -> [(name: String, content: String, attributes: [String: String])] {
        
        class ElementExtractor: SlimXMLParserDelegate {
            var elementName: String = ""
            var shouldLocalize = false
            
            var elements = [(name: String, content: String, attributes: [String: String])]()
            
            func parser(_ parser: SlimXMLParser, didStartElement element: SlimXMLElement) { }
            
            func parser(_ parser: SlimXMLParser, didEndElement element: SlimXMLElement) {
                guard element.name == self.elementName else { return }
                elements.append((name: element.name, content: element.content ?? "", attributes: element.attributes))
            }
            
            func parser(_ parser: SlimXMLParser, foundCharacters string: String) { }
            
            func parser(_ parser: SlimXMLParser, shouldCaptureElementContent elementName: String, attributes: [String : String]) -> Bool {
                return elementName == self.elementName
            }
            
            func parser(_ parser: SlimXMLParser, shouldLocalizeElementWithID elementName: String) -> Bool {
                return shouldLocalize
            }
            
            func parser(_ parser: SlimXMLParser, parseErrorOccurred parseError: Error, lineNumber: Int) {
                NSLog("\(parseError.localizedDescription) at line: \(lineNumber)")
            }
            
            init(elementName: String, localized: Bool) {
                self.elementName = elementName
                self.shouldLocalize = localized
            }
        }
        
        let parser = SlimXMLParser(xml: xml)
        let elementExtractor = ElementExtractor(elementName: elementName, localized: localized)
        parser.delegate = elementExtractor
        parser.parse()
        
        return elementExtractor.elements
    }
}

extension String {
    
    // Returns the string with leading and trailing whitespace trimmed and
    // each line trimmed of any leading whitespace.
    func linesLeftTrimmed() -> String {
        let lines = self.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n", omittingEmptySubsequences: false)
        let trimmedLines = lines.map { $0.trimmingCharacters(in: .whitespaces) }
        return trimmedLines.joined(separator: "\n")
    }
    
    func xmlEscaped() -> String {
        var escapedString = self
        escapedString = escapedString.replacingOccurrences(of: "&", with: "&amp;")
        escapedString = escapedString.replacingOccurrences(of: "<", with: "&lt;")
        escapedString = escapedString.replacingOccurrences(of: ">", with: "&gt;")
        return escapedString
    }
    
    func xmlUnescaped() -> String {
        var unEscapedString = self
        unEscapedString = unEscapedString.replacingOccurrences(of: "&amp;", with: "&")
        unEscapedString = unEscapedString.replacingOccurrences(of: "&lt;", with: "<")
        unEscapedString = unEscapedString.replacingOccurrences(of: "&gt;", with: ">")
        return unEscapedString
    }
}

