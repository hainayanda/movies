//
//  MovieVideoPreview.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public struct MovieVideoPreview: JSONAble {
    @Keyed
    public var id: Int64 = 0
    
    @Keyed
    public var results: [Result] = []
    
    public init() { }
    
    public struct Result: JSONAble {
        @Keyed
        public var id: String = ""
        
        @Keyed(key: "iso_639_1")
        public var iso639: String = ""
        
        @Keyed(key: "iso_3166_1")
        public var iso3166: String = ""
        
        @Keyed
        public var key: String = ""
        
        @Keyed
        public var name: String = ""
        
        @Keyed
        public var site: String = ""
        
        @Keyed
        public var size: Int = 0
        
        @Keyed
        public var type: String = ""
        
        public init() { }
    }
}
