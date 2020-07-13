//
//  JSONParseable+Extension.swift
//  NamadaJSON
//
//  Created by Nayanda Haberty (ID) on 10/07/20.
//

import Foundation
import JavaScriptCore

public extension JSONParseable {
    func toPrettyPrintedJSON() -> String {
        let string = toJSONString()
        let context = JSContext()
        context?.evaluateScript("var jsonPrettifier = function(json) { return JSON.stringify(JSON.parse(json), null, 4) }")
        let jsonPrettifier = context?.objectForKeyedSubscript("jsonPrettifier")
        let result = jsonPrettifier?.call(withArguments: [string])?.toString()
        return result ?? string
    }
}
