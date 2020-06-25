//
//  MovieCellVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class MoviesCellVM: ViewModel<MoviesCell> {
    @ViewModelBindable
    var cellsVMs: [MovieCellVM] = []
    
    @ViewModelBindable
    var shimmer: Bool = false
    
    var onTapMovies: ((MovieResults.Result) -> Void)?
    
    var genresMap: [Int: String] = [:] {
        didSet {
            movieRepo?.getModel()
        }
    }
    
    // MARK: Injected Repository
    var movieRepo: ModelRepository<[MovieResults.Result], Void>? {
        didSet {
            bindToModelRepositories()
            movieRepo?.getModel()
        }
    }
    
    lazy var genresRepo: ModelRepository<[MovieGenres.Genre], Void> = GenresRepo()
    
    override func bind(view: MoviesCell) {
        view.observer = self
        
        view.collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        view.collectionView.dataSource = self
        
        $cellsVMs.whenSet(view.collectionView) { collectionView, _ in
            collectionView.reloadData()
        }.equalComparation()
        
        $shimmer.whenSet(view) { view, shimmer in
            if shimmer {
                view.showShimmer()
            } else {
                view.hideShimmer()
            }
        }.equalComparation()
        
        updateView()
    }
    
    override func bindToModelRepositories() {
        movieRepo?.whenSuccess { [weak self] results in
            guard let self = self else { return }
            self.shimmer = false
            let cellsVMs: [MovieCellVM] = results.compactMap { result in
                build {
                    $0.posterImage = result.posterPath?.withTMDBImagePath
                    $0.title = result.title
                    $0.genres = result.genreIds.compactMap { self.genresMap[$0] }
                }
            }
            self.cellsVMs = cellsVMs
        }.whenFailed { [weak self] error in
            self?.shimmer = false
            print("ERROR: \(error.localizedDescription)")
            //TODO: show popup
        }
        genresRepo.whenSuccess { [weak self] results in
            guard let self = self else { return }
            var genresMap: [Int: String] = [:]
            for result in results {
                genresMap[result.id] = result.name
            }
            self.genresMap = genresMap
        }
    }
    
    override func updateModel() {
        shimmer = true
        movieRepo?.getModel()
        genresRepo.getModel()
    }
}

// MARK: View Observer

extension MoviesCellVM: MoviesCellObserver {
    func movieCell(_ cell: MoviesCell, didTapCellAt indexPath: IndexPath) {
        guard let currentModels = movieRepo?.currentModel,
            let model = currentModels[safe: indexPath.item] else { return }
        onTapMovies?(model)
    }
}

// MARK: Collection Data Source

extension MoviesCellVM: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsVMs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell,
            let cellVM = cellsVMs[safe: indexPath.item] else {
            return .init()
        }
        cellVM.bind(view: cell)
        return cell
    }
}
