//
//  GenreAPIManager.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

public protocol GenreAPIManager: APIManager {
    func genres() -> JSONAPIPromise<MovieGenres>
}

public class GenreAPI: GenreAPIManager {
    public static var instance: GenreAPIManager = GenreAPI()
    private lazy var baseServiceUrl: String = "\(baseUrl)/genre"
    
    public func genres() -> JSONAPIPromise<MovieGenres> {
        let url = "\(baseServiceUrl)/movie/list"
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
