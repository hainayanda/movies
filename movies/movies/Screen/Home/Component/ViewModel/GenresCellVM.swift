//
//  GenresCellVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class GenresCellVM: ViewModel<GenresCell> {
    @ViewModelBindable
    var cellsVMs: [GenreCellVM] = []
    
    @ViewModelBindable
    var shimmer: Bool = false
    
    var onTapGenre: ((MovieGenres.Genre) -> Void)?
    
    var colors: [UIColor] = [.alizarin, .flatOrange, .emerald, .turquoise, .peterRiver, .amethyst] {
        didSet {
            rebindModel()
        }
    }
    
    lazy var genresRepo: ModelRepository<[MovieGenres.Genre], Void> = GenresRepo()
    
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
    
    override func bindToModelRepositories() {
        genresRepo.whenSuccess { [weak self] results in
            guard let self = self else { return }
            self.shimmer = false
            let colors = self.colors
            var cellsVMs: [GenreCellVM] = []
            for (index, result) in results.enumerated() {
                let indexOfColor: Int = index % colors.count
                cellsVMs.append(build {
                    $0.color = (colors[safe: indexOfColor] ?? .black).withAlphaComponent(0.63)
                    $0.genre = result.name
                })
            }
            self.cellsVMs = cellsVMs
        }.whenFailed { [weak self] error in
            self?.shimmer = false
        }
    }
    
    override func updateModel() {
        shimmer = true
        genresRepo.getModel()
    }
}

// MARK: View Observer

extension GenresCellVM: GenresCellObserver {
    func genresCell(_ cell: GenresCell, didTapCellAt indexPath: IndexPath) {
        guard let currentModels = genresRepo.currentModel,
            let model = currentModels[safe: indexPath.item] else { return }
        onTapGenre?(model)
    }
}

// MARK: Collection Data Source

extension GenresCellVM: UICollectionViewDataSource {
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
