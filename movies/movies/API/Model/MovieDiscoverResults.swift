//
//  MovieDiscoverResults.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public struct MovieResults: JSONAble {
    @Keyed
    public var page: Int = 0
    
    @Keyed(key: "total_results")
    public var totalResults: Int = 0
    
    @Keyed(key: "total_pages")
    public var totalPages: Int = 0
    
    @Keyed
    public var results: [Result] = []
    
    public init() { }
    
    public struct Result: JSONAble {
        @Keyed
        public var popularity: Double = 0
        
        @Keyed(key: "vote_count")
        public var voteCount: Int = 0
        
        @Keyed(key: "video")
        public var hasVideoPreview: Bool = false
        
        @Keyed(key: "poster_path")
        public var posterPath: String? = nil
        
        @Keyed
        public var id: Int64 = 0
        
        @Keyed(key: "adult")
        public var isRatedAdult: Bool = false
        
        @Keyed(key: "backdrop_path")
        public var backDropPath: String? = nil
        
        @Keyed(key: "original_language")
        public var originalLanguage: String = ""
        
        @Keyed(key: "original_title")
        public var originalTitle: String = ""
        
        @Keyed(key: "genre_ids")
        public var genreIds: [Int] = []
        
        @Keyed
        public var title: String = ""
        
        @Keyed(key: "vote_average")
        public var avgVote: Double = 0
        
        @Keyed
        public var overview: String = ""
        
        @Keyed(key: "release_date")
        public var releaseDate: Date? = nil
        
        public init() { }
    }
}
