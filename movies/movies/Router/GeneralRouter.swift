//
//  GeneralRouter.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

public protocol GeneralRouterProtocol {
    func routeToMovieList(
        from viewController: UIViewController,
        with infiniteRepo: ModelRepository<[MovieResults.Result], InfiniteParam>,
        navigationTitle: String
    )
    
    func routeToMovieDetail(
        from viewController: UIViewController,
        with movie: MovieCompatible
    )
}

public class GeneralRouter: GeneralRouterProtocol {
    
    public static var shared: GeneralRouterProtocol = GeneralRouter()
    
    private init() { }
    
    public func routeToMovieList(
        from viewController: UIViewController,
        with infiniteRepo: ModelRepository<[MovieResults.Result], InfiniteParam>,
        navigationTitle: String) {
        let movieListView = GeneralTableView()
        let movieListVM = AllMoviesVM()
        movieListVM.bind(view: movieListView)
        movieListVM.movieRepo = infiniteRepo
        movieListVM.navigationTitle = navigationTitle
        viewController.navigationController?.pushViewController(movieListView, animated: true)
    }
    
    public func routeToMovieDetail(
        from viewController: UIViewController,
        with movie: MovieCompatible) {
        let movieDetailView = TranslucentTableView()
        let movieDetailVM = MovieDetailsVM()
        movieDetailVM.bind(view: movieDetailView)
        movieDetailVM.movieRepo = DetailMovieRepo(movie: movie)
        movieDetailVM.videoRepo = VideoRepo(movie: movie)
        movieDetailVM.reviewsRepo = InfiniteReviewsRepo(movie: movie)
        movieDetailVM.backDrop = (movie as? MovieResults.Result)?.backDropPath?.withTMDBImagePath
        viewController.navigationController?.pushViewController(movieDetailView, animated: true)
    }
    
}
