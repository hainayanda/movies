//
//  JSONAble.swift
//  NamadaJSON
//
//  Created by Nayanda Haberty (ID) on 02/03/20.
//

import Foundation

public extension JSONAble {
    
    private func extractKeyable(fromMirrorChild child: Mirror.Child) -> Keyable? {
        guard let label = child.label,
            let keyable = child.value as? Keyable else { return nil }
        if keyable.key == nil {
            var mutableKeyable = keyable
            let formattedKey = label.replacingOccurrences(
                of: "^_",
                with: "",
                options: .regularExpression,
                range: nil
            )
            mutableKeyable.key = formattedKey
        }
        return keyable
    }
    
    private var keyedProperties: [Keyable] {
        let reflection = Mirror(reflecting: self)
        var keyables: [Keyable] = []
        var currentReflection: Mirror? = reflection
        repeat {
            keyables.append(contentsOf: currentReflection?.children.compactMap {
                return extractKeyable(fromMirrorChild: $0)
            } ?? [])
            currentReflection = currentReflection?.superclassMirror
        } while currentReflection != nil
        return keyables
    }
    
    private func keyedProperty(for key: String) -> Keyable? {
        let reflection = Mirror(reflecting: self)
        return reflection.children
            .first {
                guard let keyable = extractKeyable(fromMirrorChild: $0) else {
                    return false
                }
                return keyable.key == key
            }?.value as? Keyable
    }
    
    subscript<Value: JSONParseable, Key: RawRepresentable>(key: Key) -> Value? where Key.RawValue == String {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue
        }
    }
    
    subscript<Value, Key: RawRepresentable>(key: Key) -> Value? where Key.RawValue == String {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue
        }
    }
    
    subscript<Value: JSONParseable>(key: String) -> Value? {
        get {
            let property = keyedProperty(for: key)
            if let serializedProperty = property as? SerializeKeyable {
                return serializedProperty.value as? Value
            }
            return property?.parseableValue as? Value
        }
        set {
            guard let property = keyedProperty(for: key) else {
                return
            }
            if let serializedProperty = property as? SerializeKeyable {
                serializedProperty.trySet(newValue)
            }
            property.trySet(jsonCompatible: newValue.toJSONCompatible())
        }
    }
    
    subscript<Value>(key: String) -> Value? {
        get {
            guard let property = keyedProperty(for: key) as? SerializeKeyable else {
                return nil
            }
            return property.value as? Value
        }
        set {
            guard let property = keyedProperty(for: key) as? SerializeKeyable else {
                return
            }
            property.trySet(newValue)
        }
    }
    
    var ignoreNull: Bool { true }
    
    func toJSONCompatible() -> JSONCompatible {
        return toJSON()
    }
    
    func toJSON() -> [String: Any] {
        let properties = self.keyedProperties
        var json: [String: Any] = [:]
        for property in properties {
            guard let key = property.key else { continue }
            let compatible = property.parseableValue.toJSONCompatible()
            if compatible is NSNull && ignoreNull {
                continue
            }
            json[key] = compatible
        }
        return json
    }
    
    func toJSONString() -> String {
        if ignoreNull {
            return constructStringIgnoreNull(from: self.keyedProperties)
        } else {
            return constructString(from: self.keyedProperties)
        }
    }
    
    private func constructStringIgnoreNull(from properties: [Keyable]) -> String {
        var jsonString = "{ "
        for property in properties {
            let string = property.valueAsJSONString
            guard string != "null", let key = property.key else {
                continue
            }
            jsonString = "\(jsonString)\"\(key)\" : \(string), "
        }
        return "\(jsonString.replacingOccurrences(of: ", $", with: " ", options: .regularExpression, range: nil))}"
    }
    
    private func constructString(from properties: [Keyable]) -> String {
        var jsonString = "{ "
        for property in properties {
            guard let key = property.key else { continue }
            jsonString = "\(jsonString)\"\(key)\" : \(property.valueAsJSONString), "
        }
        return "\(jsonString.replacingOccurrences(of: ", $", with: " ", options: .regularExpression, range: nil))}"
    }
    
    static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable {
        if let dictionary = compatible.asJSONObjectCompatible {
            let instance = Self()
            for member in dictionary {
                guard let property = instance.keyedProperty(for: member.key) else {
                    continue
                }
                let mutableProperty = property
                if let compatible = member.value as? JSONCompatible {
                    mutableProperty.trySet(jsonCompatible: compatible)
                } else if let dictionary = member.value as? [String: Any] {
                    mutableProperty.trySet(jsonCompatible: dictionary)
                } else if let array = member.value as? [Any] {
                    mutableProperty.trySet(jsonCompatible: array)
                }
            }
            return instance
        }
        throw JSONParseableError(description: "instance can't be created from non Dictionary")
    }
    
    static func parse(fromJSONString string: String) throws -> JSONParseable {
        guard let data = string.data(using: .utf8) else {
            throw JSONParseableError(description: "failed to generate data from string")
        }
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw JSONParseableError(description: "instance can't be created from Non Dictionary")
        }
        return try parse(fromJSONCompatible: dictionary)
    }
}
