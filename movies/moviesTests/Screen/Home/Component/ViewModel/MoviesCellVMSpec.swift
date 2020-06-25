//
//  MoviesCellVMSpec.swift
//  moviesTests
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import movies

class MoviesCellVMSpec: QuickSpec {
    
    override func spec() {
        describe("view model actions") {
            var movieRepoMock: RepoMock<[MovieResults.Result], Void>!
            var genreRepoMock: RepoMock<[MovieGenres.Genre], Void>!
            var moviesCellVMForTest: MoviesCellVM!
            var testableMoviesCell: MoviesCell!
            beforeEach {
                movieRepoMock = .init()
                genreRepoMock = .init()
                moviesCellVMForTest = .init()
                testableMoviesCell = .init()
                moviesCellVMForTest.movieRepo = movieRepoMock
                moviesCellVMForTest.genresRepo = genreRepoMock
                moviesCellVMForTest.bind(view: testableMoviesCell)
                
            }
        }
    }
}
