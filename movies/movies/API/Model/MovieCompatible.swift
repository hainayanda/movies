//
//  MovieCompatible.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import NamadaJSON

public protocol MovieCompatible {
    var movieId: Int64 { get }
}

extension MovieDetails: MovieCompatible {
    public var movieId: Int64 { id }
}

extension MovieResults.Result: MovieCompatible {
    public var movieId: Int64 { id }
}

extension Int64: MovieCompatible {
    public var movieId: Int64 { self }
}

public protocol YoutubeCompatible {
    var isCompatibleWithYoutube: Bool { get }
    var videoId: String? { get }
}

extension MovieVideoPreview.Result: YoutubeCompatible {
    public var videoId: String? {
        guard isCompatibleWithYoutube else { return nil }
        return key
    }
    
    public var isCompatibleWithYoutube: Bool {
        return site == "YouTube"
    }
}
