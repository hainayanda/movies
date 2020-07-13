//
//  JSONAbleMapper.swift
//  NamadaJSON
//
//  Created by Nayanda Haberty (ID) on 09/07/20.
//

import Foundation

public protocol JSONAbleMapper {
    associatedtype MappedObject
    associatedtype Parseable: JSONParseable
    func from(jsonCompatible: JSONCompatible) throws -> MappedObject
    func toJSONParseable(_ object: MappedObject) -> Parseable
    func toJSONString(_ object: MappedObject) -> String
}

extension JSONAbleMapper where MappedObject: JSONParseable {
    func toJSONString(_ object: MappedObject) -> String {
        object.toJSONString()
    }
}

public extension JSONAbleMapper {
    var forOptional: OptionalMapper<Self> {
        .init(mapper: self)
    }
    
    var forArray: ArrayMapper<Self> {
        .init(mapper: self)
    }
}

open class LongDateMapper: JSONAbleMapper {
    public typealias MappedObject = Date
    public typealias Parseable = Int64
    
    public init() { }
    
    open func from(jsonCompatible: JSONCompatible) throws -> Date {
        guard let long = jsonCompatible.asNumberCompatible?.int64Value else {
            throw JSONParseableError(description: "Cannot parse date from non number")
        }
        return .init(timeIntervalSince1970: .init(integerLiteral: long))
    }
    
    open func toJSONParseable(_ object: Date) -> Int64 {
        return Int64(object.timeIntervalSince1970)
    }
    
    open func toJSONString(_ object: Date) -> String {
        return String(Int64(object.timeIntervalSince1970))
    }
}

open class StringDateMapper: JSONAbleMapper {
    public typealias MappedObject = Date
    public typealias Parseable = String
    
    private lazy var dateFormatter: DateFormatter = .init()
    
    public init(pattern: String) {
        dateFormatter.dateFormat = pattern
    }
    
    open func from(jsonCompatible: JSONCompatible) throws -> Date {
        guard let string = jsonCompatible.asStringCompatible else {
            throw JSONParseableError(description: "Cannot parse date from non string")
        }
        guard let date = dateFormatter.date(from: string) else {
            throw JSONParseableError(description: "Failed to parse string to Date")
        }
        return date
    }
    
    open func toJSONParseable(_ object: Date) -> String {
        return dateFormatter.string(from: object)
    }
    
    open func toJSONString(_ object: Date) -> String {
        return dateFormatter.string(from: object).toJSONString()
    }
}

public class OptionalMapper<Mapper: JSONAbleMapper>: JSONAbleMapper {
    
    public typealias MappedObject = (Mapper.MappedObject)?
    public typealias Parseable = (Mapper.Parseable)?
    
    var mapper: Mapper
    var nullSerializable: MappedObject {
        Optional<Mapper.MappedObject>.init(nilLiteral: ())
    }
    
    public init(mapper: Mapper) {
        self.mapper = mapper
    }
    
    public func from(jsonCompatible: JSONCompatible) throws -> MappedObject {
        if jsonCompatible.isNull {
            return nullSerializable
        }
        return try mapper.from(jsonCompatible: jsonCompatible)
    }
    
    public func toJSONParseable(_ object: MappedObject) -> Parseable {
        guard let object = object else {
            return Optional<Mapper.Parseable>(nilLiteral: ())
        }
        return mapper.toJSONParseable(object)
    }
    
    public func toJSONString(_ object: MappedObject) -> String {
        guard let object = object else {
            return "null"
        }
        return mapper.toJSONString(object)
    }
}

public class ArrayMapper<Mapper: JSONAbleMapper>: JSONAbleMapper {
    public typealias MappedObject = [Mapper.MappedObject]
    public typealias Parseable = [Mapper.Parseable]
    
    var mapper: Mapper
    
    public init(mapper: Mapper) {
        self.mapper = mapper
    }
    
    public func from(jsonCompatible: JSONCompatible) throws -> MappedObject {
        guard let compatibleArray = jsonCompatible.asJSONArrayCompatible else {
            throw JSONParseableError(description: "Cannot parse from non array")
        }
        var array: MappedObject = []
        for element in compatibleArray {
            guard let compatible = element as? JSONCompatible else {
                throw JSONParseableError(description: "JSONCompatible array element is not JSONCompatible")
            }
            array.append(try mapper.from(jsonCompatible: compatible))
        }
        return array
    }
    
    public func toJSONParseable(_ object: MappedObject) -> Parseable {
        return object.compactMap {
            mapper.toJSONParseable($0)
        }
    }
    
    public func toJSONString(_ object: MappedObject) -> String {
        var json: String = "["
        for element in object {
            json = "\(json)\(mapper.toJSONString(element)), "
        }
        json = json.replacingOccurrences(
            of: ", $",
            with: "",
            options: .regularExpression,
            range: nil
        )
        return "\(json)]"
    }
}
