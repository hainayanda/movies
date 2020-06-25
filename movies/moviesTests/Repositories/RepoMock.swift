//
//  MovieRepoMock.swift
//  moviesTests
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
@testable import movies

class RepoMock<Result, Param>: ModelRepository<Result, Param> {
    var mockResult: Result?
    override func getModel(byParam param: Param) {
        guard let result = mockResult else {
            signalError(with: NSError(domain: "test", code: -1, userInfo: [:]))
            return
        }
        signalSuccess(with: result)
    }
}
