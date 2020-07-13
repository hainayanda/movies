//
//  JSONParseable+RawRepresentable.swift
//  NamadaJSON
//
//  Created by Nayanda Haberty (ID) on 02/03/20.
//

import Foundation

extension JSONParseable where Self: RawRepresentable, Self.RawValue: JSONParseable {
    
    public func toJSONCompatible() -> JSONCompatible {
        return rawValue.toJSONCompatible()
    }
    
    public func toJSONString() -> String {
        return rawValue.toJSONString()
    }
    
    public static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable {
        guard let realValue = try RawValue.parse(fromJSONCompatible: compatible) as? RawValue else {
            throw JSONParseableError(description: "Cannot parse from any type different than RawValue")
        }
        return Self(rawValue: realValue)
    }
    
    public static func parse(fromJSONString string: String) throws -> JSONParseable {
        guard let realValue = try RawValue.parse(fromJSONString: string) as? RawValue else {
            throw JSONParseableError(description: "Cannot parse from any type different than RawValue")
        }
        return Self(rawValue: realValue)
    }
}
