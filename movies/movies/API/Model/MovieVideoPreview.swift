//
//  MovieVideoPreview.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaJSON

public struct MovieVideoPreview: JSONAble {
    @AutoMapping
    public var id: Int64 = 0
    
    @AutoMapping
    public var results: [Result] = []
    
    public init() { }
    
    public struct Result: JSONAble {
        @AutoMapping
        public var id: String = ""
        
        @AutoMapping(key: "iso_639_1")
        public var iso639: String = ""
        
        @AutoMapping(key: "iso_3166_1")
        public var iso3166: String = ""
        
        @AutoMapping
        public var key: String = ""
        
        @AutoMapping
        public var name: String = ""
        
        @AutoMapping
        public var site: String = ""
        
        @AutoMapping
        public var size: Int = 0
        
        @AutoMapping
        public var type: String = ""
        
        public init() { }
    }
}
