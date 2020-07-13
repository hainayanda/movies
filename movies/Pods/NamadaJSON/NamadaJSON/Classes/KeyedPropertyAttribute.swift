//
//  KeyedPropertyAttribute.swift
//  NamadaJSON
//
//  Created by Nayanda Haberty (ID) on 02/03/20.
//

import Foundation

@propertyWrapper
public class AutoMapping<Value: JSONParseable>: Keyable {
    
    public var key: String?
    public var parseableValue: JSONParseable {
        return wrappedValue
    }
    public var valueAsJSONString: String {
        return parseableValue.toJSONString()
    }
    public var wrappedValue: Value
    
    public init(wrappedValue: Value, key: String) {
        self.wrappedValue = wrappedValue
        self.key = key
    }
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    public init<TKey: RawRepresentable>(wrappedValue: Value, key: TKey) where TKey.RawValue == String {
        self.wrappedValue = wrappedValue
        self.key = key.rawValue
    }
    
    public func trySet(jsonCompatible: JSONCompatible) {
        guard let optionalInstance = try? Value.parse(fromJSONCompatible: jsonCompatible),
            let instance = optionalInstance as? Value else { return }
        wrappedValue = instance
    }
}

@propertyWrapper
public class ManualMapping<Value, Mapper>: SerializeKeyable where Mapper: JSONAbleMapper, Mapper.MappedObject == Value {
    public var mapper: Mapper
    public var key: String?
    public var parseableValue: JSONParseable {
        return mapper.toJSONParseable(wrappedValue)
    }
    public var value: Any? { wrappedValue }
    public var valueAsJSONString: String {
        return mapper.toJSONString(wrappedValue)
    }
    public var wrappedValue: Value
    
    public init(wrappedValue: Value, key: String, mapper: Mapper) {
        self.wrappedValue = wrappedValue
        self.key = key
        self.mapper = mapper
    }
    
    public init(wrappedValue: Value, mapper: Mapper) {
        self.wrappedValue = wrappedValue
        self.mapper = mapper
    }
    
    public init<Key: RawRepresentable>(wrappedValue: Value, key: Key, mapper: Mapper) where Key.RawValue == String {
        self.wrappedValue = wrappedValue
        self.key = key.rawValue
        self.mapper = mapper
    }
    
    func trySet(_ some: Any?) {
        guard let value: Value = some as? Value else {
            guard let compatible = some as? JSONCompatible else {
                return
            }
            trySet(jsonCompatible: compatible)
            return
        }
        wrappedValue = value
    }
    
    public func trySet(jsonCompatible: JSONCompatible) {
        if let value = jsonCompatible as? Value {
            wrappedValue = value
            return
        }
        guard let instance = try? mapper.from(jsonCompatible: jsonCompatible) else { return }
        wrappedValue = instance
    }
}
