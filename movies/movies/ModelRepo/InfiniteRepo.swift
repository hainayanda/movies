//
//  InfiniteRepo.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

open class InfiniteMoviesRepo: ModelRepository<[MovieResults.Result], InfiniteParam> {
    var currentPage: Int = 0
    var maxPage: Int = .max
    
    open override func getModel(byParam param: InfiniteParam) {
        let page: Int = param.reload ? 1 : currentPage + 1
        guard page < maxPage else {
            signalError(with: APIError(description: "Max page excedded"))
            return
        }
        get(at: page).then(run: { [weak self] result in
            guard let self = self else { return }
            guard let parsed = result.parsedResponse else {
                self.signalError(with: APIError(description: "No Result"))
                return
            }
            self.currentPage = page
            self.maxPage = parsed.totalPages
            if param.reload {
                self.currentModel = parsed.results
            } else {
                self.currentModel?.append(contentsOf: parsed.results)
            }
            self.signalSuccess(with: self.currentModel ?? [])
        }, whenFailed: { [weak self] error in
            self?.signalError(with: error)
        })
    }
    
    open func get(at page: Int) -> JSONAPIPromise<MovieResults> {
        fatalError("function get(at: page) at InfiniteMoviesRepo should be overridden")
    }
}

public class InfiniteParam: Initiable {
    var nextPage: Bool = false
    var reload: Bool {
        get {
            return !nextPage
        }
        set {
            nextPage = !newValue
        }
    }
    
    required public init() { }
}

class PopularMoviesRepo: InfiniteMoviesRepo {
    lazy var apiManager: MovieAPIManager = MovieAPI.instance
    
    override func get(at page: Int) -> JSONAPIPromise<MovieResults> {
        return apiManager.popular(at: page)
    }
}

class LatestMoviesRepo: InfiniteMoviesRepo {
    lazy var apiManager: MovieAPIManager = MovieAPI.instance
    
    override func get(at page: Int) -> JSONAPIPromise<MovieResults> {
        return apiManager.latest(at: page)
    }
}

class UpcomingMoviesRepo: InfiniteMoviesRepo {
    lazy var apiManager: MovieAPIManager = MovieAPI.instance
    
    override func get(at page: Int) -> JSONAPIPromise<MovieResults> {
        return apiManager.upcoming(at: page)
    }
}

class GenresMoviesRepo: InfiniteMoviesRepo {
    
    private var genre: MovieGenres.Genre
    
    lazy var apiManager: DiscoverAPIManager = DiscoverAPI.instance
    
    init(for genre: MovieGenres.Genre) {
        self.genre = genre
        super.init()
    }
    
    override func get(at page: Int) -> JSONAPIPromise<MovieResults> {
        return apiManager.discover(genres: [genre], at: page)
    }
}

class InfiniteReviewsRepo: ModelRepository<[MovieReviews.Review], InfiniteParam> {
    lazy var apiManager: MovieAPIManager = MovieAPI.instance
    
    var currentPage: Int = 0
    var maxPage: Int = .max
    
    var movie: MovieCompatible
    
    init(movie: MovieCompatible) {
        self.movie = movie
    }
    
    override func getModel(byParam param: InfiniteParam) {
        let page: Int = param.reload ? 1 : currentPage + 1
        guard page < maxPage else {
            signalError(with: APIError(description: "Max page excedded"))
            return
        }
        apiManager.reviews(of: movie, at: page).then(run: { [weak self] result in
            guard let self = self else { return }
            guard let parsed = result.parsedResponse else {
                self.signalError(with: APIError(description: "No Result"))
                return
            }
            self.currentPage = page
            self.maxPage = parsed.totalPages
            if param.reload {
                self.currentModel = parsed.results
            } else {
                self.currentModel?.append(contentsOf: parsed.results)
            }
            self.signalSuccess(with: self.currentModel ?? [])
        }, whenFailed: { [weak self] error in
            self?.signalError(with: error)
        })
    }
}
