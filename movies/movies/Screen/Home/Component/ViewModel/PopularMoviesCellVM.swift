//
//  PopularMovieCellVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class PopularMoviesCellVM: ViewModel<PopularMoviesCell> {
    @ViewModelBindable
    var cellsVMs: [RatedMovieCellVM] = []
    
    @ViewModelBindable
    var shimmer: Bool = false
    
    var onTapMovies: ((MovieResults.Result) -> Void)?
    
    lazy var popularMovieRepo: ModelRepository<[MovieResults.Result], InfiniteParam> = PopularMoviesRepo()
    
    override func bind(view: PopularMoviesCell) {
        view.observer = self
        
        view.collectionView.register(RatedMovieCell.self, forCellWithReuseIdentifier: RatedMovieCell.reuseIdentifier)
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
        popularMovieRepo.whenSuccess { [weak self] results in
            guard let self = self else { return }
            self.shimmer = false
            let cellsVMs: [RatedMovieCellVM] = results.compactMap { result in
                build {
                    $0.posterImage = result.posterPath?.withTMDBImagePath
                    $0.rate = result.avgVote
                    $0.title = result.title
                }
            }
            self.cellsVMs = cellsVMs
        }.whenFailed { [weak self] error in
            self?.shimmer = false
        }
    }
    
    override func updateModel() {
        shimmer = true
        popularMovieRepo.getModel(byParam: build { $0.reload = true })
    }
}

// MARK: View Observer

extension PopularMoviesCellVM: PopularMoviesCellObserver {
    func popularMovieCell(_ cell: PopularMoviesCell, didTapCellAt indexPath: IndexPath) {
        guard let currentModels = popularMovieRepo.currentModel,
            let model = currentModels[safe: indexPath.item] else { return }
        onTapMovies?(model)
    }
}

// MARK: Collection Data Source

extension PopularMoviesCellVM: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsVMs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatedMovieCell.reuseIdentifier, for: indexPath) as? RatedMovieCell,
            let cellVM = cellsVMs[safe: indexPath.item] else {
            return .init()
        }
        cellVM.bind(view: cell)
        return cell
    }
}
