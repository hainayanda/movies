//
//  MovieDetails.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public struct MovieDetails: JSONAble {
    @Keyed(key: "adult")
    public var isRatedAdult: Bool = false
    
    @Keyed(key: "backdrop_path")
    public var backDropPath: String? = nil
    
    @Keyed
    public var budget: Int = 0
    
    @Keyed
    public var genres: [MovieGenres.Genre] = []
    
    @Keyed
    public var homepage: String? = nil
    
    @Keyed
    public var id: Int64 = 0
    
    @Keyed(key: "imdb_id")
    public var imdbId: String? = nil
    
    @Keyed(key: "original_language")
    public var originalLanguage: String = ""
    
    @Keyed(key: "original_title")
    public var originalTitle: String = ""
    
    @Keyed
    public var overview: String = ""
    
    @Keyed
    public var popularity: Double = 0
    
    @Keyed(key: "poster_path")
    public var posterPath: String? = nil
    
    @Keyed(key: "production_companies")
    public var productionCompanies: [ProductionCompany] = []
    
    @Keyed(key: "production_countries")
    public var productionCountries: [ProductionCountry] = []
    
    @Keyed(key: "release_date")
    public var releaseDate: Date? = nil
    
    @Keyed
    public var revenue: Int = 0
    
    @Keyed
    public var runtime: Int = 0
    
    @Keyed(key: "spoken_languages")
    public var spokenLanguages: [SpokenLanguage] = []
    
    @Keyed
    public var status: String = ""
    
    @Keyed
    public var tagline: String = ""
    
    @Keyed
    public var title: String = ""
    
    @Keyed(key: "video")
    public var hasVideoPreview: Bool = false
    
    @Keyed(key: "vote_average")
    public var avgVote: Double = 0
    
    @Keyed(key: "vote_count")
    public var voteCount: Int = 0
    
    public init() { }
    
    public struct SpokenLanguage: JSONAble {
        @Keyed(key: "iso_639_1")
        public var iso: String = ""
        
        @Keyed
        public var name: String = ""
        
        public init() { }
    }
    
    public struct ProductionCountry: JSONAble {
        @Keyed(key: "iso_3166_1")
        public var iso: String = ""
        
        @Keyed
        public var name: String = ""
        
        public init() { }
    }
    
    public struct ProductionCompany: JSONAble {
        @Keyed
        public var id: Int64 = 0
        
        @Keyed(key: "logo_path")
        public var logoPath: String? = nil
        
        @Keyed
        public var name: String = ""
        
        @Keyed(key: "origin_country")
        public var originCountry: String = ""
        
        public init() { }
    }
}
