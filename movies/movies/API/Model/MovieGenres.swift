//
//  MovieGenre.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public struct MovieGenres: JSONAble {

    @Keyed
    public var genres: [Genre] = []
    
    public init() { }
    
    public struct Genre: JSONAble {
        @Keyed
        public var id: Int = 0
        
        @Keyed
        public var name: String = ""
        
        public init() { }
    }
}
