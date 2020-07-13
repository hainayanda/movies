//
//  HomeProtocols.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

protocol HomeView: class {
    var presenter: HomePresenter? { get set }
    func hideRefreshControl()
    func shimmer(section: HomeScreenSection)
    func showHeadline(from results: [BackdropCellVM])
    func showPopular(from results: [RatedMovieCellVM])
    func showNewest(from results: [MovieCellVM])
    func showComingSoon(from results: [MovieCellVM])
    func showGenres(from results: [GenreCellVM])
    var navigationTitle: String? { get set }
}

protocol HomePresenter: class {
    func didTap(genreCell: GenreCellVM)
    func didTapPopular(movieCell: RatedMovieCellVM)
    func didTapHeadline(movieCell: BackdropCellVM)
    func didTapNew(movieCell: MovieCellVM)
    func didTapComingSoon(movieCell: MovieCellVM)
    func didTapAllPopularMovies()
    func didTapAllNewestMovies()
    func didTapAllComingSoonMovies()
    func didNeedReload()
    func sectionTitles(for types: HomeScreenSection) -> String?
}

protocol HomeInteractor: class {
    func getHeadlines(then: @escaping ([MovieResultWithGenre]) -> Void, onFailed: @escaping (Error?) -> Void)
    func getMostPopular(then: @escaping ([MovieResultWithGenre]) -> Void, onFailed: @escaping (Error?) -> Void)
    func getGenres(then: @escaping ([MovieGenres.Genre]) -> Void, onFailed: @escaping (Error?) -> Void)
    func getNewest(then: @escaping ([MovieResultWithGenre]) -> Void, onFailed: @escaping (Error?) -> Void)
    func getComingSoon(then: @escaping ([MovieResultWithGenre]) -> Void, onFailed: @escaping (Error?) -> Void)
}

protocol HomeRouter {
    func routeToMovieScreen(_ movie: MovieResults.Result, from: UIViewController)
    func routeToAllPopularMovies(from: UIViewController)
    func routeToAllNewestMovies(from: UIViewController)
    func routeToAllComingSoonMovies(from: UIViewController)
    func routeToAllMoviesScreen(by genre: MovieGenres.Genre, from: UIViewController)
}

public struct MovieResultWithGenre: Initiable {
    public var movie: MovieResults.Result
    public var genres: [String] = []
    
    public init() { movie = .init() }
}

public enum HomeScreenSection: Int, CaseIterable {
    case headline = 0
    case popular = 1
    case genre = 2
    case new = 3
    case soon = 4
}
