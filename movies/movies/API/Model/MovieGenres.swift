//
//  MovieGenre.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaJSON

public struct MovieGenres: JSONAble {

    @AutoMapping
    public var genres: [Genre] = []
    
    public init() { }
    
    public struct Genre: JSONAble {
        @AutoMapping
        public var id: Int = 0
        
        @AutoMapping
        public var name: String = ""
        
        public init() { }
    }
}
