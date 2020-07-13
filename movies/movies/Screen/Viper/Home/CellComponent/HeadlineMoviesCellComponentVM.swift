//
//  HeadlineMoviesCellComponentVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

//MARK: Dumb Version of HeadlineMoviesCellVM

class HeadlineMoviesCellComponentVM: ViewModel<HeadlineMoviesCell> {
    @ViewModelBindable
    var cellsVMs: [BackdropCellVM] = []
    
    @ViewModelBindable
    var shimmer: Bool = false
    
    @ViewModelBindable
    var page: Int = 0
    
    @ViewModelBindable
    var numberOfPages: Int = 0
    
    var onTapHeadline: ((BackdropCellVM) -> Void)?
    
    var carouselStarted: Bool = false {
        didSet {
            guard oldValue != carouselStarted else { return }
            if carouselStarted {
                startCarousel()
            }
        }
    }
    
    override func bind(view: HeadlineMoviesCell) {
        view.observer = self
        view.collectionView.register(BackdropCell.self, forCellWithReuseIdentifier: BackdropCell.reuseIdentifier)
        view.collectionView.dataSource = self
        
        $cellsVMs.whenSet(view.collectionView) { collectionView, _ in
            collectionView.reloadData()
        }.equalComparation()
        
        $page.whenSet(view) { view, page in
            view.pageControl.currentPage = page
            view.collectionView.scrollToItem(at: .init(row: page, section: 0), at: .centeredHorizontally, animated: true)
        }.equalComparation()
        
        $numberOfPages.whenSet(view.pageControl) { pageControl, numberOfPages in
            pageControl.numberOfPages = numberOfPages
        }.equalComparation()
        
        $shimmer.whenSet(view) { view, shimmer in
            view.pageControl.isHidden = shimmer
            if shimmer {
                view.showShimmer()
            } else {
                view.hideShimmer()
            }
        }.equalComparation()
        
        updateView()
    }
    
    private func startCarousel() {
        dispatchOnMainThread(after: .now() + 4.5) { [weak self] in
            guard let self = self, self.carouselStarted else { return }
            self.page = (self.page + 1) % self.numberOfPages
            self.startCarousel()
        }
    }
}

// MARK: View Observer

extension HeadlineMoviesCellComponentVM: HeadlineMoviesCellObserver {
    func headlineMovieCell(_ cell: HeadlineMoviesCell, didTapCellAt indexPath: IndexPath) {
        guard let selectedModel = cellsVMs[safe: indexPath.item] else { return }
        onTapHeadline?(selectedModel)
    }
    
    func headlineMovieCell(_ cell: HeadlineMoviesCell, didScrolledTo indexPath: IndexPath) {
        page = indexPath.item
    }
}

// MARK: Collection Data Source

extension HeadlineMoviesCellComponentVM: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellsVMs.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCell.reuseIdentifier, for: indexPath) as? BackdropCell,
            let cellVM = cellsVMs[safe: indexPath.item] else {
            return .init()
        }
        cellVM.bind(view: cell)
        return cell
    }
}

