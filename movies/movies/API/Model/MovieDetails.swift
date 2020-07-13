//
//  MovieDetails.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaJSON

public struct MovieDetails: JSONAble {
    @AutoMapping(key: "adult")
    public var isRatedAdult: Bool = false
    
    @AutoMapping(key: "backdrop_path")
    public var backDropPath: String? = nil
    
    @AutoMapping
    public var budget: Int = 0
    
    @AutoMapping
    public var genres: [MovieGenres.Genre] = []
    
    @AutoMapping
    public var homepage: String? = nil
    
    @AutoMapping
    public var id: Int64 = 0
    
    @AutoMapping(key: "imdb_id")
    public var imdbId: String? = nil
    
    @AutoMapping(key: "original_language")
    public var originalLanguage: String = ""
    
    @AutoMapping(key: "original_title")
    public var originalTitle: String = ""
    
    @AutoMapping
    public var overview: String = ""
    
    @AutoMapping
    public var popularity: Double = 0
    
    @AutoMapping(key: "poster_path")
    public var posterPath: String? = nil
    
    @AutoMapping(key: "production_companies")
    public var productionCompanies: [ProductionCompany] = []
    
    @AutoMapping(key: "production_countries")
    public var productionCountries: [ProductionCountry] = []
    
    @ManualMapping(key: "release_date", mapper: StringDateMapper(pattern: "yyyy-MM-dd").forOptional)
    public var releaseDate: Date? = nil
    
    @AutoMapping
    public var revenue: Int = 0
    
    @AutoMapping
    public var runtime: Int = 0
    
    @AutoMapping(key: "spoken_languages")
    public var spokenLanguages: [SpokenLanguage] = []
    
    @AutoMapping
    public var status: String = ""
    
    @AutoMapping
    public var tagline: String = ""
    
    @AutoMapping
    public var title: String = ""
    
    @AutoMapping(key: "video")
    public var hasVideoPreview: Bool = false
    
    @AutoMapping(key: "vote_average")
    public var avgVote: Double = 0
    
    @AutoMapping(key: "vote_count")
    public var voteCount: Int = 0
    
    public init() { }
    
    public struct SpokenLanguage: JSONAble {
        @AutoMapping(key: "iso_639_1")
        public var iso: String = ""
        
        @AutoMapping
        public var name: String = ""
        
        public init() { }
    }
    
    public struct ProductionCountry: JSONAble {
        @AutoMapping(key: "iso_3166_1")
        public var iso: String = ""
        
        @AutoMapping
        public var name: String = ""
        
        public init() { }
    }
    
    public struct ProductionCompany: JSONAble {
        @AutoMapping
        public var id: Int64 = 0
        
        @AutoMapping(key: "logo_path")
        public var logoPath: String? = nil
        
        @AutoMapping
        public var name: String = ""
        
        @AutoMapping(key: "origin_country")
        public var originCountry: String = ""
        
        public init() { }
    }
}
