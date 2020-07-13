//
//  Protocols.swift
//  NamadaJSON
//
//  Created by Nayanda Haberty (ID) on 02/03/20.
//

import Foundation

public protocol JSONCompatible {
    var asStringCompatible: String? { get }
    var asNumberCompatible: NSNumber? { get }
    var asBoolCompatible: Bool? { get }
    var asJSONObjectCompatible: [String: Any]? { get }
    var asJSONArrayCompatible: [Any]? { get }
    var asNullCompatible: NSNull? { get }
    var isNull: Bool { get }
    var isNotNull: Bool { get }
}

public protocol JSONParseable {
    func toJSONCompatible() -> JSONCompatible
    func toJSONString() -> String
    static func parse(fromJSONCompatible compatible: JSONCompatible) throws -> JSONParseable
    static func parse(fromJSONString string: String) throws -> JSONParseable
}

public protocol JSONNumberParseable: JSONParseable {
    var nsNumber: NSNumber { get }
    static func parse(fromNSNumber nsNumber: NSNumber) throws -> JSONParseable
}

public protocol JSONAble: JSONParseable {
    init()
    var ignoreNull: Bool { get }
    func toJSON() -> [String: Any]
}

public protocol Keyable {
    var key: String? { get set }
    var parseableValue: JSONParseable { get }
    var valueAsJSONString: String { get }
    func trySet(jsonCompatible: JSONCompatible)
}

protocol SerializeKeyable: Keyable {
    var value: Any? { get }
    func trySet(_ some: Any?)
}
