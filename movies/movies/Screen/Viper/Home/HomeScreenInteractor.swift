//
//  HomeScreenInteractor.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

class HomeScreenInteractor {
    
    // MARK: Entity
    lazy var headlineRepo: ModelRepository<[MovieResults.Result], Void> = HeadlineMoviesRepo()
    lazy var genresRepo: ModelRepository<[MovieGenres.Genre], Void> = GenresRepo()
    lazy var popularMovieRepo: ModelRepository<[MovieResults.Result], InfiniteParam> = PopularMoviesRepo()
    lazy var newMovieRepo: ModelRepository<[MovieResults.Result], Void> = NewestMovieRepo()
    lazy var comingSoonMovieRepo: ModelRepository<[MovieResults.Result], Void> = ComingSoonMovieRepo()
    var popularPendingUpdate: Bool = false
    var headlinePendingUpdate: Bool = false
    var newMoviePendingUpdate: Bool = false
    var comingSoonPendingUpdate: Bool = false
    
    func updatePendingRequest() {
        if popularPendingUpdate {
            popularPendingUpdate = false
            popularMovieRepo.signalWithExisting()
        }
        if headlinePendingUpdate {
            headlinePendingUpdate = false
            headlineRepo.signalWithExisting()
        }
        if newMoviePendingUpdate {
            newMoviePendingUpdate = false
            newMovieRepo.signalWithExisting()
        }
        if comingSoonPendingUpdate {
            comingSoonPendingUpdate = false
            comingSoonMovieRepo.signalWithExisting()
        }
    }
}

extension HomeScreenInteractor: HomeInteractor {
    func getComingSoon(then: @escaping ([MovieResultWithGenre]) -> Void, onFailed: @escaping (Error?) -> Void) {
        comingSoonMovieRepo.whenSuccess { [weak self] result in
            guard let self = self else { return }
            guard let genres = self.genresRepo.currentModel else {
                self.comingSoonPendingUpdate = true
                return
            }
            then(result.compactMap { movie in
                build {
                    $0.movie = movie
                    $0.genres = genres.compactMap { genre in
                        if movie.genreIds.contains(genre.id) {
                            return genre.name
                        }
                        return nil
                    }
                }
            })
        }.whenFailed { error in
            onFailed(error)
        }.getModel()
    }
    
    func getHeadlines(then: @escaping ([MovieResultWithGenre]) -> Void, onFailed: @escaping (Error?) -> Void) {
        headlineRepo.whenSuccess { [weak self] result in
            guard let self = self else { return }
            guard let genres = self.genresRepo.currentModel else {
                self.headlinePendingUpdate = true
                return
            }
            then(result.compactMap { movie in
                build {
                    $0.movie = movie
                    $0.genres = genres.compactMap { genre in
                        if movie.genreIds.contains(genre.id) {
                            return genre.name
                        }
                        return nil
                    }
                }
            })
        }.whenFailed { error in
            onFailed(error)
        }.getModel()
    }
    
    func getMostPopular(then: @escaping ([MovieResultWithGenre]) -> Void, onFailed: @escaping (Error?) -> Void) {
        popularMovieRepo.whenSuccess { [weak self] result in
            guard let self = self else { return }
            guard let genres = self.genresRepo.currentModel else {
                self.popularPendingUpdate = true
                return
            }
            then(result.compactMap { movie in
                build {
                    $0.movie = movie
                    $0.genres = genres.compactMap { genre in
                        if movie.genreIds.contains(genre.id) {
                            return genre.name
                        }
                        return nil
                    }
                }
            })
        }.whenFailed { error in
            onFailed(error)
        }.getModel(byParam: build {
            $0.reload = true
        })
    }
    
    func getGenres(then: @escaping ([MovieGenres.Genre]) -> Void, onFailed: @escaping (Error?) -> Void) {
        genresRepo.whenSuccess { result in
            then(result)
            self.updatePendingRequest()
        }.whenFailed { error in
            onFailed(error)
        }.getModel()
    }
    
    func getNewest(then: @escaping ([MovieResultWithGenre]) -> Void, onFailed: @escaping (Error?) -> Void) {
        newMovieRepo.whenSuccess { [weak self] result in
            guard let self = self else { return }
            guard let genres = self.genresRepo.currentModel else {
                self.newMoviePendingUpdate = true
                return
            }
            then(result.compactMap { movie in
                build {
                    $0.movie = movie
                    $0.genres = genres.compactMap { genre in
                        if movie.genreIds.contains(genre.id) {
                            return genre.name
                        }
                        return nil
                    }
                }
            })
        }.whenFailed { error in
            onFailed(error)
        }.getModel()
    }
    
    
    
}
