//
//  HomeScreenRouter.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class HomeScreenRouter: HomeRouter {
    func routeToMovieScreen(_ movie: MovieResults.Result, from: UIViewController) {
        let movieDetailView = TranslucentTableView()
        let movieDetailVM = MovieDetailsVM()
        movieDetailVM.bind(view: movieDetailView)
        movieDetailVM.movieRepo = DetailMovieRepo(movie: movie)
        movieDetailVM.videoRepo = VideoRepo(movie: movie)
        movieDetailVM.reviewsRepo = InfiniteReviewsRepo(movie: movie)
        movieDetailVM.backDrop = movie.backDropPath?.withTMDBImagePath
        from.navigationController?.pushViewController(movieDetailView, animated: true)
    }
    
    func routeToAllPopularMovies(from: UIViewController) {
        let movieListView = GeneralTableView()
        let movieListVM = AllMoviesVM()
        movieListVM.bind(view: movieListView)
        movieListVM.movieRepo = PopularMoviesRepo()
        movieListVM.navigationTitle = "most popular"
        from.navigationController?.pushViewController(movieListView, animated: true)
    }
    
    func routeToAllNewestMovies(from: UIViewController) {
        let movieListView = GeneralTableView()
        let movieListVM = AllMoviesVM()
        movieListVM.bind(view: movieListView)
        movieListVM.movieRepo = LatestMoviesRepo()
        movieListVM.navigationTitle = "new movies"
        from.navigationController?.pushViewController(movieListView, animated: true)
    }
    
    func routeToAllComingSoonMovies(from: UIViewController) {
        let movieListView = GeneralTableView()
        let movieListVM = AllMoviesVM()
        movieListVM.bind(view: movieListView)
        movieListVM.movieRepo = UpcomingMoviesRepo()
        movieListVM.navigationTitle = "coming soon"
        from.navigationController?.pushViewController(movieListView, animated: true)
    }
    
    func routeToAllMoviesScreen(by genre: MovieGenres.Genre, from: UIViewController) {
        let movieListView = GeneralTableView()
        let movieListVM = AllMoviesVM()
        movieListVM.bind(view: movieListView)
        movieListVM.movieRepo = GenresMoviesRepo(for: genre)
        movieListVM.navigationTitle = genre.name
        from.navigationController?.pushViewController(movieListView, animated: true)
    }
    
    
}
