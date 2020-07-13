//
//  MovieDiscoverResults.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaJSON

public struct MovieResults: JSONAble {
    @AutoMapping
    public var page: Int = 0
    
    @AutoMapping(key: "total_results")
    public var totalResults: Int = 0
    
    @AutoMapping(key: "total_pages")
    public var totalPages: Int = 0
    
    @AutoMapping
    public var results: [Result] = []
    
    public init() { }
    
    public struct Result: JSONAble {
        @AutoMapping
        public var popularity: Double = 0
        
        @AutoMapping(key: "vote_count")
        public var voteCount: Int = 0
        
        @AutoMapping(key: "video")
        public var hasVideoPreview: Bool = false
        
        @AutoMapping(key: "poster_path")
        public var posterPath: String? = nil
        
        @AutoMapping
        public var id: Int64 = 0
        
        @AutoMapping(key: "adult")
        public var isRatedAdult: Bool = false
        
        @AutoMapping(key: "backdrop_path")
        public var backDropPath: String? = nil
        
        @AutoMapping(key: "original_language")
        public var originalLanguage: String = ""
        
        @AutoMapping(key: "original_title")
        public var originalTitle: String = ""
        
        @AutoMapping(key: "genre_ids")
        public var genreIds: [Int] = []
        
        @AutoMapping
        public var title: String = ""
        
        @AutoMapping(key: "vote_average")
        public var avgVote: Double = 0
        
        @AutoMapping
        public var overview: String = ""
        
        @ManualMapping(key: "release_date", mapper: StringDateMapper(pattern: "yyyy-MM-dd").forOptional)
        public var releaseDate: Date? = nil
        
        public init() { }
    }
}
