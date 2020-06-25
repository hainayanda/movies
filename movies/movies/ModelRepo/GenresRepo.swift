//
//  GenresRepo.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation

class GenresRepo: ModelRepository<[MovieGenres.Genre], Void> {
    
    lazy var sharedRepo: SharedGenresRepo = SharedGenresRepo.shared
    
    override func getModel(byParam param: Void) {
        sharedRepo.getGenres(run: { [weak self] result in
            guard let self = self else { return }
            self.currentModel = result
            self.signalSuccess(with: result)
            }, whenFailed: { [weak self] error in
                self?.signalError(with: error)
        })
    }
}

// MARK: Shared Repo
// since the genres is used in many places

class SharedGenresRepo {
    
    static var shared: SharedGenresRepo = .init()
    
    private init() { }
    
    lazy var apiManager: GenreAPIManager = GenreAPI.instance
    
    var fetchedGenres: [MovieGenres.Genre]?
    
    func getGenres(run closure: @escaping ([MovieGenres.Genre]) -> Void, whenFailed failClosure: @escaping (Error) -> Void) {
        if let current = self.fetchedGenres {
            closure(current)
            return
        }
        apiManager.genres().then(run: { [weak self] result in
            guard let self = self else { return }
            guard let parsed = result.parsedResponse else {
                failClosure(APIError(description: "No Result"))
                return
            }
            self.fetchedGenres = parsed.genres
            closure(parsed.genres)
        }, whenFailed: failClosure)
    }
}
