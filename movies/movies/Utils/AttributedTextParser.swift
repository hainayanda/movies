//
//  AttributedTextParser.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//
//  Copied from my own code

import Foundation
import UIKit

public extension NSAttributedString {
    static func parse(
        customElements: [String: AttributedTextBuilder.Model] = [:],
        _ strToParse: String) -> NSAttributedString {
        let parser = AttributedTextParser(customElements: customElements, strToParse)
        let result = parser.parsedAttributedString ?? NSAttributedString(string: strToParse)
        return result
    }
}

public extension String {
    var asParsedAttributedString: NSAttributedString {
        .parse(self)
    }
    
    func parseAsAttributedString(with customElements: [String: AttributedTextBuilder.Model]) -> NSAttributedString {
        return .parse(customElements: customElements, self)
    }
}

public class AttributedTextParser: NSObject {
    
    public typealias StyleModel = AttributedTextBuilder.Model
    
    public var text: String {
        didSet {
            parseXML()
        }
    }
    public var customElements: [String: StyleModel] = [:] {
        didSet {
            parseXML()
        }
    }
    public var parsedAttributedString: NSAttributedString? { parseToAttributedString() }
    private var parsedModels: [Model] = []
    
    private var elementStackStyles: [(String, StyleModel)] = []
    
    public init(customElements: [String: StyleModel] = [:], _ str: String) {
        self.text = str
        self.customElements = customElements
        super.init()
        parseXML()
    }
    
    func parseXML() {
        guard let data = text.data(using: .utf8) else { return }
        let parser = XMLParser(data: data)
        parser.delegate = self
        let parseSuccess = parser.parse()
        if parseSuccess {
            print("attributed xml parsed successfully!")
        } else {
            print("failed to parse attributed xml")
        }
    }
    
    private func parseToAttributedString() -> NSAttributedString? {
        var builder: AttributedTextBuilder?
        for (index, model) in parsedModels.enumerated() {
            if index == 0 {
                builder = NSAttributedString
                    .startWithAttrs(model.model)
                    .text(model.text)
            } else {
                builder = builder?
                    .nextAttrs(model.model)
                    .text(model.text)
            }
        }
        guard let attrBuilder = builder else { return nil }
        return attrBuilder.build()
    }
}

extension AttributedTextParser: XMLParserDelegate {
    
    public func parserDidStartDocument(_ parser: XMLParser) {
        parsedModels = []
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let currentStackStyle = elementStackStyles.last {
            parsedModels.append(Model(model: currentStackStyle.1, text: string))
        } else {
            parsedModels.append(Model(model: .init(), text: string))
        }
    }
    
    public func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]) {
        if elementName == "style" {
            let styleModel = extractStyle(from: attributeDict)
            addToStack(for: styleModel, with: elementName)
        } else if customElements.keys.contains(elementName),
            let styleModel = customElements[elementName] {
            let styleFromAttributes = extractStyle(from: attributeDict)
            addToStack(for: styleModel.combine(with: styleFromAttributes), with: elementName)
        }
    }
    
    public func parser(_ parser: XMLParser,
                       didEndElement elementName: String,
                       namespaceURI: String?,
                       qualifiedName qName: String?) {
        guard let currentElement = elementStackStyles.last?.0,
            currentElement == elementName else { return }
        elementStackStyles.removeLast()
    }
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        parsedModels = parsedModels.filter { !$0.text.isEmpty }
    }
    
    private func addToStack(for styleModel: AttributedTextParser.StyleModel, with elementName: String) {
        if let currentStackStyle = elementStackStyles.last {
            let combinedStyle = currentStackStyle.1.combine(with: styleModel)
            elementStackStyles.append((elementName, combinedStyle))
            return
        }
        elementStackStyles.append((elementName, styleModel))
    }
    
    private func extractStyle(from attributeDict: [String: String]) -> StyleModel {
        let styleModel = StyleModel()
        var fontName: String?
        var fontSize: CGFloat?
        for (key, value) in attributeDict {
            if key ~= "(textC|c)olor" {
                styleModel.color = UIColor.init(hex: value)
            } else if key ~= "(back[gG]round|bg)Color?" {
                styleModel.background = UIColor.init(hex: value)
            } else if key ~= "under[lL]ine" {
                styleModel.underlined = Bool(value)
            } else if key == "shadow" {
                styleModel.shadowed = Bool(value)
            } else if key ~= "(textF|f)ont",
                let name = UIFont.familyNames.first(where: { $0 == value }) {
                fontName = name
            } else if key ~= "(textF|f)ontSize", let size: Double = Double(value) {
                fontSize = CGFloat(size)
            } else if key ~= "under[lL]ineColor" {
                styleModel.underlineColor =  UIColor.init(hex: value)
                styleModel.underlined = true
            } else if key ~= "link([Uu]rl)?" {
                styleModel.linkUrl = value
            }
        }
        if let fontName = fontName, let fontSize = fontSize,
            let font = UIFont(name: fontName, size: fontSize) {
            styleModel.font = font
        }
        return styleModel
    }
}

extension AttributedTextParser {
    
    class Model {
        let model: StyleModel
        let text: String
        
        init(model: StyleModel, text: String) {
            self.model = model
            self.text = text
        }
    }
}
