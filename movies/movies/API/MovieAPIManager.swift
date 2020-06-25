//
//  TMDBAPIManager.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public protocol MovieAPIManager: APIManager {
    func videoPreview(of movie: MovieCompatible) -> JSONAPIPromise<MovieVideoPreview>
    func popular(at page: Int) -> JSONAPIPromise<MovieResults>
    func upcoming(at page: Int) -> JSONAPIPromise<MovieResults>
    func reviews(of movie: MovieCompatible, at page: Int) -> JSONAPIPromise<MovieReviews>
    func latest(at page: Int) -> JSONAPIPromise<MovieResults>
    func detail(of movie: MovieCompatible) -> JSONAPIPromise<MovieDetails>
}

public class MovieAPI: MovieAPIManager {
    
    public static var instance: MovieAPIManager = MovieAPI()
    private lazy var baseServiceUrl: String = "\(baseUrl)/movie"
    
    public func detail(of movie: MovieCompatible) -> JSONAPIPromise<MovieDetails> {
        let url = "\(baseServiceUrl)/\(movie.movieId)"
        return request(build {
            $0.url = url
            $0.urlParams = [
                "api_key": apiKeyV3,
                "language": "en-US"
            ]
            $0.method = .get
        })
    }
    
    public func reviews(of movie: MovieCompatible, at page: Int) -> JSONAPIPromise<MovieReviews> {
        let url = "\(baseServiceUrl)/\(movie.movieId)/reviews"
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
    
    public func videoPreview(of movie: MovieCompatible) -> JSONAPIPromise<MovieVideoPreview> {
        let url = "\(baseServiceUrl)/\(movie.movieId)/videos"
        return request(build {
            $0.url = url
            $0.urlParams = [
                "api_key": apiKeyV3,
                "language": "en-US",
            ]
            $0.method = .get
        })
    }
    
    public func popular(at page: Int) -> JSONAPIPromise<MovieResults> {
        let url = "\(baseServiceUrl)/popular"
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
        let url = "\(baseServiceUrl)/upcoming"
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
    
    public func latest(at page : Int) -> JSONAPIPromise<MovieResults> {
        let url = "\(baseServiceUrl)/now_playing"
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
    
}
