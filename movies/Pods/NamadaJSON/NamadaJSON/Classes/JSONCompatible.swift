//
//  JSONCompatible.swift
//  NamadaJSON
//
//  Created by Nayanda Haberty (ID) on 04/03/20.
//

import Foundation

public extension JSONCompatible {
    var asStringCompatible: String? { nil }
    var asNumberCompatible: NSNumber? { nil }
    var asJSONObjectCompatible: [String: Any]? { nil }
    var asJSONArrayCompatible: [Any]? { nil }
    var asBoolCompatible: Bool? { nil }
    var asNullCompatible: NSNull? { nil }
    var isNotNull: Bool {
        return !isNull
    }
    var isNull: Bool {
        return asStringCompatible == nil && asNumberCompatible == nil
            && asJSONObjectCompatible == nil && asJSONArrayCompatible == nil
            && asBoolCompatible == nil
    }
}

extension Bool: JSONCompatible {
    public var asBoolCompatible: Bool? { return self }
}

extension NSNumber: JSONCompatible {
    public var asNumberCompatible: NSNumber? { self }
    public var asBoolCompatible: Bool? { self.boolValue }
}

extension String: JSONCompatible {
    public var asStringCompatible: String? { self }
}

extension NSString: JSONCompatible {
    public var asStringCompatible: String? { self as String }
}

extension Array: JSONCompatible where Element == Any {
    public var asJSONArrayCompatible: [Any]? { self.asCompatible }
    
    var asCompatible: [Any] {
        var compatibles: [Any] = []
        for element in self {
            if let compatible = element as? JSONCompatible {
                compatibles.append(compatible)
            } else if let dictionary = element as? [String: Any] {
                compatibles.append(dictionary.asCompatible)
            } else if let array = element as? [Any] {
                compatibles.append(array.asCompatible)
            } else if let parseable = element as? JSONParseable {
                compatibles.append(parseable.toJSONCompatible())
            } else {
                compatibles.append(NSNull())
            }
        }
        return compatibles
    }
}

extension NSArray: JSONCompatible {
    public var asJSONArrayCompatible: [Any]? { (self as? [Any])?.asCompatible }
}

extension Dictionary: JSONCompatible where Key == String, Value == Any {
    public var asJSONObjectCompatible: [String: Any]? { self.asCompatible }
    
    var asCompatible: [String: Any] {
        var compatibles: [String: Any] = [:]
        for member in self {
            if let compatible = member.value as? JSONCompatible {
                compatibles[member.key] = compatible
            } else if let dictionary = member.value as? [String: Any] {
                compatibles[member.key] = dictionary.asCompatible
            } else if let array = member.value as? [Any] {
                compatibles[member.key] = array.asCompatible
            } else if let parseable = member.value as? JSONParseable {
                compatibles[member.key] = parseable.toJSONCompatible()
            } else {
                compatibles[member.key] = NSNull()
            }
        }
        return compatibles
    }
}
extension NSDictionary: JSONCompatible {
    public var asJSONObjectCompatible: [String: Any]? { (self as? [String: Any])?.asCompatible }
}

extension NSNull: JSONCompatible {
    public var asNullCompatible: NSNull? { self }
}
