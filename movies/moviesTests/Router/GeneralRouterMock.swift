//
//  GeneralRouterMock.swift
//  moviesTests
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import movies

class GeneralRouterMock: GeneralRouterProtocol {
    var movieListObserver: ((UIViewController,  ModelRepository<[MovieResults.Result], InfiniteParam>, String) -> Void)?
    func routeToMovieList(
        from viewController: UIViewController,
        with infiniteRepo: ModelRepository<[MovieResults.Result], InfiniteParam>,
        navigationTitle: String) {
        movieListObserver?(viewController, infiniteRepo, navigationTitle)
    }
    
    var movieDetailObserver: ((UIViewController, MovieCompatible) -> Void)?
    func routeToMovieDetail(
        from viewController: UIViewController,
        with movie: MovieCompatible) {
        movieDetailObserver?(viewController, movie)
    }
    
}
