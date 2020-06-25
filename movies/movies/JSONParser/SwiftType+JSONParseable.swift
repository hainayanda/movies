//
//  SwiftType+JSONParseable.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//
//  Copied from my own repository: https://github.com/nayanda1/NamadaJSON

import Foundation

extension String: JSONParseable {
    
    public func toJSONCompatible() -> JSONCompatible {
        return self as NSString
    }
    
    public func toJSONString() -> String {
        return "\"\(self)\""
    }
    
    public static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable {
        if let casted = compatible.asStringCompatible {
            return casted
        }
        throw JSONParseableError(description: "instance can't be created from Non String")
    }
    
    public static func parse(fromJSONString string: String) throws -> JSONParseable {
        guard string.isJSONAble else {
            throw JSONParseableError(description: "String format is invalid")
        }
        var trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        trimmed.remove(at: trimmed.startIndex)
        trimmed.remove(at: trimmed.endIndex)
        return trimmed
    }
    
    private var isJSONAble: Bool {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        guard let first = trimmed.first, first == "\"" || first == "'" else { return false }
        let stringBorder = first
        for (index, char) in trimmed.enumerated() where index > 0 && index < trimmed.count - 1 && char == stringBorder {
            return false
        }
        return true
    }
}

extension Bool: JSONParseable {
    
    public func toJSONCompatible() -> JSONCompatible {
        return self
    }
    
    public func toJSONString() -> String {
        return "\(self)"
    }
    
    public static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable {
        if let casted = compatible.asBoolCompatible {
            return casted
        }
        throw JSONParseableError(description: "instance can't be created from Non Boolean")
    }
    
    private static var map: [String: Bool] = [
        "true": true,
        "True": true,
        "TRUE": true,
        "false": false,
        "False": false,
        "FALSE": false,
    ]
    
    public static func parse(fromJSONString string: String) throws -> JSONParseable {
        guard let bool = map[string] else {
            throw JSONParseableError(description: "string format is invalid")
        }
        return bool
    }
}

extension Array: JSONParseable where Element: JSONParseable {
    
    public func toJSONCompatible() -> JSONCompatible {
        var compatibleArray: [Any] = []
        for member in self {
            compatibleArray.append(
                member.toJSONCompatible()
            )
        }
        return compatibleArray
    }
    
    public func toJSONString() -> String {
        var json: String = "["
        for element in self {
            json = "\(json)\(element.toJSONString()), "
        }
        json = json.replacingOccurrences(
            of: ", $",
            with: "",
            options: .regularExpression,
            range: nil
        )
        return "\(json)]"
    }
    
    public static func parse(fromJSONArray array: [Any]) throws -> JSONParseable {
        var instance = Self.init()
        for member in array {
            if let casted = member as? Element {
                instance.append(casted)
            } else if let compatibleJSON = member as? JSONCompatible,
                let parsed = try Element.parse(fromJSONCompatible: compatibleJSON) as? Element {
                instance.append(parsed)
            } else if let dictionary = member as? [String: Any],
                let parsed = try Element.parse(fromJSONCompatible: dictionary) as? Element {
                instance.append(parsed)
            } else if let array = member as? [Any],
                let parsed = try Element.parse(fromJSONCompatible: array) as? Element {
                instance.append(parsed)
            }
        }
        return instance
    }
    
    public static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable {
        if let casted = compatible.asJSONArrayCompatible {
            return try parse(fromJSONArray: casted)
        }
        throw JSONParseableError(description: "instance can't be created from Non Array")
    }
    
    public static func parse(fromJSONString string: String) throws -> JSONParseable {
        guard let data = string.data(using: .utf8) else {
            throw JSONParseableError(description: "failed to generate data from string")
        }
        guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any] else {
            throw JSONParseableError(description: "instance can't be created from Non Array")
        }
        return try parse(fromJSONArray: array)
    }
}

extension Optional: JSONParseable where Wrapped: JSONParseable {
    
    public func toJSONCompatible() -> JSONCompatible {
        guard let unwrapped = self else {
            return NSNull()
        }
        return unwrapped.toJSONCompatible()
    }
    
    public func toJSONString() -> String {
        guard let unwrapped = self else {
            return "null"
        }
        return unwrapped.toJSONString()
    }
    
    public static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable {
        return try Wrapped.parse(fromJSONCompatible: compatible)
    }
    
    public static func parse(fromJSONString string: String) throws -> JSONParseable {
        let parseable: [String] = ["null", "NULL", "nil", "Null"]
        let null: Self = nil
        if parseable.contains(string) { return null }
        return try Wrapped.parse(fromJSONString: string)
    }
}

