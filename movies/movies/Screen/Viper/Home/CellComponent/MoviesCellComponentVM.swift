//
//  MoviesCellComponentVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

//MARK: Dumb Version of MoviesCellVM

class MoviesCellComponentVM: ViewModel<MoviesCell> {
    @ViewModelBindable
    var cellsVMs: [MovieCellVM] = []
    
    @ViewModelBindable
    var shimmer: Bool = false
    
    var onTapMovies: ((MovieCellVM) -> Void)?
    
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
}

// MARK: View Observer

extension MoviesCellComponentVM: MoviesCellObserver {
    func movieCell(_ cell: MoviesCell, didTapCellAt indexPath: IndexPath) {
        guard let selectedVM = cellsVMs[safe: indexPath.item] else { return }
        onTapMovies?(selectedVM)
    }
}

// MARK: Collection Data Source

extension MoviesCellComponentVM: UICollectionViewDataSource {
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
