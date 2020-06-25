//
//  JSONParseableError.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//
//  Copied from my own repository: https://github.com/nayanda1/NamadaJSON

import Foundation

public struct JSONParseableError: Error {
    
    private var description: String
    public var localizedDescription: String { description }
    
    public init(description: String) {
        self.description = description
    }
}
