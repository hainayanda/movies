//
//  GenresCellComponentVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

//MARK: Dumb Version of GenresCellVM

class GenresCellComponentVM: ViewModel<GenresCell> {
    @ViewModelBindable
    var cellsVMs: [GenreCellVM] = []
    
    @ViewModelBindable
    var shimmer: Bool = false
    
    var onTapGenre: ((GenreCellVM) -> Void)?
    
    var colors: [UIColor] = [.alizarin, .flatOrange, .emerald, .turquoise, .peterRiver, .amethyst] {
        didSet {
            rebindModel()
        }
    }
    
    override func bind(view: GenresCell) {
        view.observer = self
        
        view.collectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.reuseIdentifier)
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

extension GenresCellComponentVM: GenresCellObserver {
    func genresCell(_ cell: GenresCell, didTapCellAt indexPath: IndexPath) {
        guard let selectedVM = cellsVMs[safe: indexPath.item] else { return }
        onTapGenre?(selectedVM)
    }
}

// MARK: Collection Data Source

extension GenresCellComponentVM: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsVMs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.reuseIdentifier, for: indexPath) as? GenreCell,
            let cellVM = cellsVMs[safe: indexPath.item] else {
            return .init()
        }
        cellVM.bind(view: cell)
        return cell
    }
}

