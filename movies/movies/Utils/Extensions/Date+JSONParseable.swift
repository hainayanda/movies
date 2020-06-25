//
//  Date+JSONParseable.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

extension Date: JSONParseable {
    
    public func toJSONCompatible() -> JSONCompatible {
        return toJSONString()
    }
    
    public func toJSONString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    public static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let string = compatible as? String, let date = formatter.date(from: string) else {
            throw JSONParseableError(description: "Cannot parse from any type different than RawValue")
        }
        return date
    }
    
    public static func parse(fromJSONString string: String) throws -> JSONParseable {
        return try parse(fromJSONCompatible: string)
    }
}
