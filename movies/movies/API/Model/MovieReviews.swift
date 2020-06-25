//
//  MovieReviews.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public struct MovieReviews: JSONAble {
    @Keyed
    public var page: Int = 0
    
    @Keyed(key: "total_results")
    public var totalResults: Int = 0
    
    @Keyed(key: "total_pages")
    public var totalPages: Int = 0
    
    @Keyed
    public var results: [Review] = []
    
    public init() { }
    
    public struct Review: JSONAble {
        
        @Keyed
        public var author: String = ""
        
        @Keyed
        public var content: String = ""
        
        @Keyed
        public var id: String = ""
        
        @Keyed
        public var url: String? = nil
        
        public init() { }
        
    }
}
