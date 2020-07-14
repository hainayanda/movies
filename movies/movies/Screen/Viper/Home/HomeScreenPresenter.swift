//
//  HomeScreenPresenter.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class HomeScreenPresenter<View: UIViewController>: VCPresenter<View, HomeInteractor, HomeRouter> where View: HomeView {
    
    var genreColors: [UIColor] = [.alizarin, .flatOrange, .emerald, .turquoise, .peterRiver, .amethyst]
    
    lazy var generalFailureClosure: (Error?) -> Void = { [weak self] error in
        self?.didFailure(error)
    }
    
    open override func setup(view: View?)  {
        view?.navigationTitle = "movr"
    }
    
}

extension HomeScreenPresenter: HomePresenter {
    func didNeedReload() {
        guard let view = view else { return }
        for section in HomeScreenSection.allCases {
            view.shimmer(section: section)
        }
        interactor.getGenres(then: { [weak self] genres in
            guard let self = self, let view = self.view else { return }
            var colorIndex = 0
            view.showGenres(from: genres.compactMap { genre in
                colorIndex = (colorIndex + 1) % self.genreColors.count
                return build {
                    $0.tag = genre
                    $0.genre = genre.name
                    $0.color = self.genreColors[safe: colorIndex] ?? .black
                }
            })
        }, onFailed: generalFailureClosure)
        interactor.getNewest(then: { [weak self] newest in
            guard let self = self, let view = self.view else { return }
            view.showNewest(from: newest.compactMap { new in
                return build {
                    $0.tag = new
                    $0.genres = new.genres
                    $0.posterImage = new.movie.posterPath?.withTMDBImagePath
                    $0.title = new.movie.title
                }
            })
        }, onFailed: generalFailureClosure)
        interactor.getHeadlines(then: { [weak self] headlines in
            guard let self = self, let view = self.view else { return }
            view.showHeadline(from: headlines.compactMap { headline in
                return build {
                    $0.tag = headline
                    $0.backdropImage = headline.movie.backDropPath?.withTMDBImagePath
                }
            })
        }, onFailed: generalFailureClosure)
        interactor.getMostPopular(then: { [weak self] populars in
            guard let self = self, let view = self.view else { return }
            view.showPopular(from: populars.compactMap { popular in
                return build {
                    $0.tag = popular
                    $0.posterImage = popular.movie.posterPath?.withTMDBImagePath
                    $0.rate = popular.movie.avgVote
                    $0.title = popular.movie.title
                }
            })
        }, onFailed: generalFailureClosure)
        interactor.getComingSoon(then: { [weak self] soons in
            guard let self = self, let view = self.view else { return }
            view.showComingSoon(from: soons.compactMap { soon in
                return build {
                    $0.tag = soon
                    $0.genres = soon.genres
                    $0.posterImage = soon.movie.posterPath?.withTMDBImagePath
                    $0.title = soon.movie.title
                }
            })
        }, onFailed: generalFailureClosure)
        view.hideRefreshControl()
    }
    
    func didFailure(_ error: Error?) {
        view?.showToast(message: error?.localizedDescription ?? "Unknown Error")
    }
    
    func didTap(genreCell: GenreCellVM) {
        guard let view = view, let genre = genreCell.tag as? MovieGenres.Genre else { return }
        router.routeToAllMoviesScreen(by: genre, from: view)
    }
    
    func didTapPopular(movieCell: RatedMovieCellVM) {
        guard let view = view, let movie = movieCell.tag as? MovieResultWithGenre else { return }
        router.routeToMovieScreen(movie.movie, from: view)
    }
    
    func didTapHeadline(movieCell: BackdropCellVM) {
        guard let view = view, let movie = movieCell.tag as? MovieResultWithGenre else { return }
        router.routeToMovieScreen(movie.movie, from: view)
    }
    
    func didTapNew(movieCell: MovieCellVM) {
        guard let view = view, let movie = movieCell.tag as? MovieResultWithGenre else { return }
        router.routeToMovieScreen(movie.movie, from: view)
    }
    
    func didTapComingSoon(movieCell: MovieCellVM) {
        guard let view = view, let movie = movieCell.tag as? MovieResultWithGenre else { return }
        router.routeToMovieScreen(movie.movie, from: view)
    }
    
    func didTapAllPopularMovies() {
        guard let view = view else { return }
        router.routeToAllPopularMovies(from: view)
    }
    
    func didTapAllNewestMovies() {
        guard let view = view else { return }
        router.routeToAllNewestMovies(from: view)
    }
    
    func didTapAllComingSoonMovies() {
        guard let view = view else { return }
        router.routeToAllComingSoonMovies(from: view)
    }
    
    func sectionTitles(for types: HomeScreenSection) -> String? {
        switch types {
        case .genre:
            return "GENRES"
        case .new:
            return "NEW"
        case .popular:
            return "MOST POPULAR MOVIES"
        case .soon:
            return "COMING SOON"
        default:
            return nil
        }
    }
}
