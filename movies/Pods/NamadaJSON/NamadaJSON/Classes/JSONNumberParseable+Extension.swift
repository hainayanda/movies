//
//  JSONNumberParseable+Extension.swift
//  NamadaJSON
//
//  Created by Nayanda Haberty (ID) on 04/03/20.
//

import Foundation

public extension JSONNumberParseable {
    func toJSONCompatible() -> JSONCompatible {
        return nsNumber
    }
    
    func toJSONString() -> String {
        return nsNumber.stringValue
    }
    
    static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable {
        if let nsNumber = compatible.asNumberCompatible {
            return try parse(fromNSNumber: nsNumber)
        }
        throw JSONParseableError(description: "instance can't be created from Non Number")
    }
    
    static func parse(fromJSONString string: String) throws -> JSONParseable {
        guard let nsNumber = NumberFormatter().number(from: string) else {
            throw JSONParseableError(description: "String format is invalid")
        }
        return try parse(fromNSNumber: nsNumber)
    }
}

extension Int: JSONNumberParseable {
    
    public var nsNumber: NSNumber { .init(value: self) }
    
    public static func parse(fromNSNumber nsNumber: NSNumber) throws -> JSONParseable {
        nsNumber.intValue
    }
}

extension Int8: JSONNumberParseable {
    
    public var nsNumber: NSNumber { .init(value: self) }
    
    public static func parse(fromNSNumber nsNumber: NSNumber) throws -> JSONParseable {
        nsNumber.int8Value
    }
}

extension Int16: JSONNumberParseable {
    
    public var nsNumber: NSNumber { .init(value: self) }
    
    public static func parse(fromNSNumber nsNumber: NSNumber) throws -> JSONParseable {
        nsNumber.int16Value
    }
}

extension Int32: JSONNumberParseable {
    
    public var nsNumber: NSNumber { .init(value: self) }
    
    public static func parse(fromNSNumber nsNumber: NSNumber) throws -> JSONParseable {
        nsNumber.int32Value
    }
}

extension Int64: JSONNumberParseable {
    
    public var nsNumber: NSNumber { .init(value: self) }
    
    public static func parse(fromNSNumber nsNumber: NSNumber) throws -> JSONParseable {
        nsNumber.int64Value
    }
}

extension Float: JSONNumberParseable {
    
    public var nsNumber: NSNumber { .init(value: self) }
    
    public static func parse(fromNSNumber nsNumber: NSNumber) throws -> JSONParseable {
        nsNumber.floatValue
    }
}

extension Double: JSONNumberParseable {
    
    public var nsNumber: NSNumber { .init(value: self) }
    
    public static func parse(fromNSNumber nsNumber: NSNumber) throws -> JSONParseable {
        nsNumber.doubleValue
    }
}
