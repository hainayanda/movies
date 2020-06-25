//
//  AttributedTextBuilder.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//
//  Copied from my own code

import Foundation
import UIKit

public extension NSAttributedString {
    static func builder() -> AttributedTextBuilder {
        return .init()
    }
    
    static func startEmptyAttrs(text: String) -> AttributedTextBuilder {
        return startWithAttrs(.init()).text(text)
    }
    
    static func startWith(font: UIFont) -> AttributedTextBuilder.Appender {
        return startWithAttrs {
            $0.font = font
        }
    }
    
    static func startWith(color: UIColor) -> AttributedTextBuilder.Appender {
        return startWithAttrs {
            $0.color = color
        }
    }
    
    static func startWith(bgColor: UIColor) -> AttributedTextBuilder.Appender {
        return startWithAttrs {
            $0.background = bgColor
        }
    }
    
    static func startWith(linkUrl: String) -> AttributedTextBuilder.Appender {
        return startWithAttrs {
            $0.linkUrl = linkUrl
        }
    }
    
    static func startWith(underlineColor: UIColor) -> AttributedTextBuilder.Appender {
        return startWithAttrs {
            $0.underlineColor = underlineColor
            $0.underlined = true
        }
    }
    
    static func startWithShadowed() -> AttributedTextBuilder.Appender {
        return startWithAttrs {
            $0.shadowed = true
        }
    }
    
    static func startWithUnderlined() -> AttributedTextBuilder.Appender {
        return startWithAttrs {
            $0.underlined = true
        }
    }
    
    static func startWithAttrs(_ model: AttributedTextBuilder.Model) -> AttributedTextBuilder.Appender {
        builder().nextAttrs(model)
    }
    
    static func startWithAttrs(_ attrsBuilder: (AttributedTextBuilder.Model) -> Void) -> AttributedTextBuilder.Appender {
        return builder().nextAttrs(attrsBuilder)
    }
}

public class AttributedTextBuilder {
    var attributedString: NSMutableAttributedString = .init()
    
    public func nextEmptyAttrs(text: String) -> AttributedTextBuilder {
        return nextAttrs(.init()).text(text)
    }
    
    public func next(font: UIFont) -> Appender {
        return nextAttrs {
            $0.font = font
        }
    }
    
    public func next(color: UIColor) -> Appender {
        return nextAttrs {
            $0.color = color
        }
    }
    
    public func next(bgColor: UIColor) -> Appender {
        return nextAttrs {
            $0.background = bgColor
        }
    }
    
    public func next(linkUrl: String) -> Appender {
        return nextAttrs {
            $0.linkUrl = linkUrl
        }
    }
    
    public func next(underlineColor: UIColor) -> Appender {
        return nextAttrs {
            $0.underlineColor = underlineColor
            $0.underlined = true
        }
    }
    
    public func nextShadowed() -> Appender {
        return nextAttrs {
            $0.shadowed = true
        }
    }
    
    public func nextUnderlined() -> Appender {
        return nextAttrs {
            $0.underlined = true
        }
    }
    
    public func nextAttrs(_ builder: (Model) -> Void) -> Appender {
        let model = Model()
        builder(model)
        return nextAttrs(model)
    }
    
    public func nextAttrs(_ model: Model) -> Appender {
        var attributes: [NSAttributedString.Key: Any] = [:]
        if let color = model.color {
            attributes[.foregroundColor] = color
        }
        if let background = model.background {
            attributes[.backgroundColor] = background
        }
        if let font: UIFont = model.font {
            attributes[NSAttributedString.Key.font] = font
        }
        if model.shadowed == true {
            let shadow = NSShadow()
            shadow.shadowBlurRadius = 1
            shadow.shadowOffset = CGSize(width: 1, height: 1)
            shadow.shadowColor = UIColor.black.withAlphaComponent(0.18)
            attributes[.shadow] = shadow
        }
        if model.underlined == true {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        if let underlineColor = model.underlineColor {
            attributes[.underlineColor] = underlineColor
        }
        if let linkUrl = model.linkUrl {
            attributes[.link] = linkUrl
        }
        return .init(builder: self, attributes: attributes)
    }
    
    public func build() -> NSAttributedString {
        let buildedAttributedString = attributedString
        attributedString = .init()
        return buildedAttributedString
    }
}

public extension AttributedTextBuilder {
    class Appender {
        var builder: AttributedTextBuilder
        var attributes: [NSAttributedString.Key: Any]
        init(builder: AttributedTextBuilder, attributes: [NSAttributedString.Key: Any]) {
            self.attributes = attributes
            self.builder = builder
        }
        
        public func text(_ text: String) -> AttributedTextBuilder {
            builder.attributedString.append(.init(string: text, attributes: attributes))
            return builder
        }
    }
}

public extension AttributedTextBuilder {
    final class Model: Initiable {
        public var color: UIColor?
        public var shadowed: Bool?
        public var underlined: Bool?
        public var font: UIFont?
        public var background: UIColor?
        public var underlineColor: UIColor?
        public var linkUrl: String?
        
        required public init() {}
        
        public func combine(with model: Model) -> Model {
            let combination: Model = .init()
            combination.color = model.color ?? color
            combination.shadowed = model.shadowed ?? shadowed
            combination.underlined = model.underlined ?? underlined
            combination.font = model.font ?? font
            combination.background = model.background ?? background
            combination.underlineColor = model.underlineColor ?? underlineColor
            combination.linkUrl = model.linkUrl ?? linkUrl
            return combination
        }
    }
}
