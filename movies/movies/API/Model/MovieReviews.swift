//
//  MovieReviews.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaJSON

public struct MovieReviews: JSONAble {
    @AutoMapping
    public var page: Int = 0
    
    @AutoMapping(key: "total_results")
    public var totalResults: Int = 0
    
    @AutoMapping(key: "total_pages")
    public var totalPages: Int = 0
    
    @AutoMapping
    public var results: [Review] = []
    
    public init() { }
    
    public struct Review: JSONAble {
        
        @AutoMapping
        public var author: String = ""
        
        @AutoMapping
        public var content: String = ""
        
        @AutoMapping
        public var id: String = ""
        
        @AutoMapping
        public var url: String? = nil
        
        public init() { }
        
    }
}
