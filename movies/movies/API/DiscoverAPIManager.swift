//
//  DiscoverAPIManager.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public protocol DiscoverAPIManager: APIManager {
    func discover() -> JSONAPIPromise<MovieResults>
    func discover(genres: [MovieGenres.Genre], at page: Int) -> JSONAPIPromise<MovieResults>
}

public class DiscoverAPI: DiscoverAPIManager {
    public static var instance: DiscoverAPIManager = DiscoverAPI()
    private lazy var baseServiceUrl: String = "\(baseUrl)/discover"
    
    public func discover() -> JSONAPIPromise<MovieResults> {
        return discover(genres: [], at: 1)
    }
    
    public func discover(genres: [MovieGenres.Genre], at page: Int) -> JSONAPIPromise<MovieResults> {
        let url = "\(baseServiceUrl)/movie"
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
    
}
