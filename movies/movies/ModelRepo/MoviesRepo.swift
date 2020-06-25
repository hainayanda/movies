//
//  MoviesRepo.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

class NewestMovieRepo: ModelRepository<[MovieResults.Result], Void> {
    lazy var apiManager: MovieAPIManager = MovieAPI.instance
    
    override func getModel(byParam param: Void) {
        apiManager.latest(at: 1).then(run: { [weak self] result in
            guard let self = self else { return }
            guard let parsed = result.parsedResponse else {
                self.signalError(with: APIError(description: "No Result"))
                return
            }
            self.currentModel = parsed.results
            self.signalSuccess(with: parsed.results)
        }, whenFailed: { [weak self] error in
            self?.signalError(with: error)
        })
    }
}

class ComingSoonMovieRepo: ModelRepository<[MovieResults.Result], Void> {
    lazy var apiManager: MovieAPIManager = MovieAPI.instance
    
    override func getModel(byParam param: Void) {
        apiManager.upcoming(at: 1).then(run: { [weak self] result in
            guard let self = self else { return }
            guard let parsed = result.parsedResponse else {
                self.signalError(with: APIError(description: "No Result"))
                return
            }
            self.currentModel = parsed.results
            self.signalSuccess(with: parsed.results)
        }, whenFailed: { [weak self] error in
            self?.signalError(with: error)
        })
    }
}

class DetailMovieRepo: ModelRepository<MovieDetails, Void> {
    lazy var apiManager: MovieAPIManager = MovieAPI.instance
    
    var movie: MovieCompatible
    
    init(movie: MovieCompatible) {
        self.movie = movie
    }
    
    override func getModel(byParam param: Void) {
        if let current = self.currentModel {
            self.signalSuccess(with: current)
            return
        }
        apiManager.detail(of: movie).then(run: { [weak self] result in
            guard let self = self else { return }
            guard let parsed = result.parsedResponse else {
                self.signalError(with: APIError(description: "No Result"))
                return
            }
            self.currentModel = parsed
            self.signalSuccess(with: parsed)
            }, whenFailed: { [weak self] error in
                self?.signalError(with: error)
        })
    }
}

class VideoRepo: ModelRepository<MovieVideoPreview, Void> {
    lazy var apiManager: MovieAPIManager = MovieAPI.instance
    
    var movie: MovieCompatible
    
    init(movie: MovieCompatible) {
        self.movie = movie
    }
    
    override func getModel(byParam param: Void) {
        if let current = self.currentModel {
            self.signalSuccess(with: current)
            return
        }
        apiManager.videoPreview(of: movie).then(run: { [weak self] result in
            guard let self = self else { return }
            guard let parsed = result.parsedResponse else {
                self.signalError(with: APIError(description: "No Result"))
                return
            }
            self.currentModel = parsed
            self.signalSuccess(with: parsed)
            }, whenFailed: { [weak self] error in
                self?.signalError(with: error)
        })
    }
}
