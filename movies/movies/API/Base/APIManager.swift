//
//  APIManager.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Alamofire
import NamadaJSON

public protocol APIManager {
    func request<ResultType: JSONParseable>(_ request: APIRequest) -> JSONAPIPromise<ResultType>
}

public extension APIManager {
    var apiKeyV3: String { "399ec687d698797735b7c1f7efb7d9e0" }
    var apiKeyV4: String { """
        eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzOTllYzY4N2Q2OTg3OTc3MzViN2MxZjdlZmI3ZDllMCIsInN1YiI6IjVlZjI0YzNhZDExZTBlMDAzNmIwN2ExMiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.2j2Hj3AwZvB3-QtoAYvSA_FG_vOR3aPN7QWKapf6hHo
        """
    }
    var baseUrl: String { "https://api.themoviedb.org/3" }

    func request<ResultType: JSONParseable>(_ request: APIRequest) -> JSONAPIPromise<ResultType> {
        let dataRequest = AF.request(
            request.urlWithParam,
            method: request.method,
            parameters: request.params,
            encoding: request.encoding,
            headers: request.headers
        )
        return JSONAPIPromise(request: dataRequest)
    }
}
