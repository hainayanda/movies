//
//  TMDBAPIManager.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public protocol MovieAPIManager: APIManager {
}

public class TMDBAPI: MovieAPIManager {
    public static var instance: MovieAPIManager = TMDBAPI()
    private let apiKeyV3: String = "399ec687d698797735b7c1f7efb7d9e0"
    private let apiKeyV4: String = """
    eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzOTllYzY4N2Q2OTg3OTc3MzViN2MxZjdlZmI3ZDllMCIsInN1YiI6IjVlZjI0YzNhZDExZTBlMDAzNmIwN2ExMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2j2Hj3AwZvB3-QtoAYvSA_FG_vOR3aPN7QWKapf6hHo
    """
    private var baseUrl: String = "https://api.themoviedb.org/3"
    
    public func videoPreview(of movie: MovieCompatible) -> JSONAPIPromise<MovieVideoPreview> {
        let url = "\(baseUrl)/movie/\(movie.movieId)/videos"
        return request(build {
            $0.url = url
            $0.urlParams = [
                "api_key": apiKeyV3,
                "language": "en-US",
            ]
            $0.method = .get
        })
    }
    
    public func topRated(at page: Int) -> JSONAPIPromise<MovieResults> {
        let url = "\(baseUrl)/movie/top_rated"
        return request(build {
            $0.url = url
            $0.urlParams = [
                "api_key": apiKeyV3,
                "language": "en-US",
                "page": "\(page)"
            ]
            $0.method = .get
        })
    }
    
    public func popular(at page: Int) -> JSONAPIPromise<MovieResults> {
        let url = "\(baseUrl)/movie/popular"
        return request(build {
            $0.url = url
            $0.urlParams = [
                "api_key": apiKeyV3,
                "language": "en-US",
                "page": "\(page)"
            ]
            $0.method = .get
        })
    }
    
    public func upcoming(at page: Int) -> JSONAPIPromise<MovieResults> {
        let url = "\(baseUrl)/movie/upcoming"
        return request(build {
            $0.url = url
            $0.urlParams = [
                "api_key": apiKeyV3,
                "language": "en-US",
                "page": "\(page)"
            ]
            $0.method = .get
        })
    }
    
    public func discover(genres: [MovieGenres.Genre], at page: Int) -> JSONAPIPromise<MovieResults> {
        let url = "\(baseUrl)/discover/movie"
        return request(build {
            $0.url = url
            $0.urlParams = [
                "api_key": apiKeyV3,
                "language": "en-US",
                "include_video": "true",
                "sort_by": "popularity.desc",
                "page": "\(page)"
            ]
            let genresInString = genres.compactMap({ "\($0.id)" }).joined()
            if !genresInString.isEmpty {
                $0.urlParams["with_genres"] = genresInString
            }
            $0.method = .get
        })
    }
    
    public func genres() -> JSONAPIPromise<MovieGenres> {
        let url = "\(baseUrl)/genre/movie/list"
        return request(build {
            $0.url = url
            $0.urlParams = [
                "api_key": apiKeyV3,
                "language": "en-US",
            ]
            $0.method = .get
        })
    }
    
}
