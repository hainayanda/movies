//
//  PopularMoviesCellComponentVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

//MARK: Dumb Version of PopularMoviesCellVM

class PopularMoviesCellComponentVM: ViewModel<PopularMoviesCell> {
    @ViewModelBindable
    var cellsVMs: [RatedMovieCellVM] = []
    
    @ViewModelBindable
    var shimmer: Bool = false
    
    var onTapMovies: ((RatedMovieCellVM) -> Void)?
    
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
}

// MARK: View Observer

extension PopularMoviesCellComponentVM: PopularMoviesCellObserver {
    func popularMovieCell(_ cell: PopularMoviesCell, didTapCellAt indexPath: IndexPath) {
        guard let selectedVM = cellsVMs[safe: indexPath.item] else { return }
        onTapMovies?(selectedVM)
    }
}

// MARK: Collection Data Source

extension PopularMoviesCellComponentVM: UICollectionViewDataSource {
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
