//
//  Error.swift
//  NamadaJSON
//
//  Created by Nayanda Haberty (ID) on 02/03/20.
//

import Foundation

public struct JSONParseableError: Error {
    public var localizedDescription: String
    
    public init(description: String) {
        self.localizedDescription = description
    }
}
