//
//  KeyedPropertyAttribute.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//
//  Copied from my own repository: https://github.com/nayanda1/NamadaJSON

import Foundation

@propertyWrapper
public class Keyed<T: JSONParseable>: Keyable {
    
    public var key: String?
    public var value: JSONParseable? {
        get {
            return wrappedValue
        }
        set {
            guard let value: T = newValue as? T else { return }
            wrappedValue = value
        }
    }
    public var wrappedValue: T
    
    public init(wrappedValue: T, key: String) {
        self.wrappedValue = wrappedValue
        self.key = key
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
    
    public init<TKey: RawRepresentable>(wrappedValue: T, key: TKey) where TKey.RawValue == String {
        self.wrappedValue = wrappedValue
        self.key = key.rawValue
    }
    
    public func trySet(jsonCompatible: JSONCompatible) {
        guard let optionalInstance = try? T.parse(fromJSONCompatible: jsonCompatible),
            let instance = optionalInstance as? T else { return }
        wrappedValue = instance
    }
}
