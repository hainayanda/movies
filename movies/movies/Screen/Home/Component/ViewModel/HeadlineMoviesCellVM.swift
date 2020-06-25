//
//  HeadlineMoviesCellVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class HeadlineMoviesCellVM: ViewModel<HeadlineMoviesCell> {
    @ViewModelBindable
    var cellsVMs: [BackdropCellVM] = []
    
    @ViewModelBindable
    var shimmer: Bool = false
    
    @ViewModelBindable
    var page: Int = 0
    
    @ViewModelBindable
    var numberOfPages: Int = 0
    
    var onTapHeadline: ((MovieResults.Result) -> Void)?
    
    var carouselStarted: Bool = false {
        didSet {
            guard oldValue != carouselStarted else { return }
            if carouselStarted {
                startCarousel()
            }
        }
    }
    
    lazy var headlineRepo: ModelRepository<[MovieResults.Result], Void> = HeadlineMoviesRepo()
    
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
    
    override func bindToModelRepositories() {
        headlineRepo.whenSuccess { [weak self] results in
            guard let self = self else { return }
            self.shimmer = false
            let cellsVMs: [BackdropCellVM] = results.compactMap { result in
                build {
                    $0.backdropImage = result.backDropPath?.withTMDBImagePath
                }
            }
            self.cellsVMs = cellsVMs
            self.carouselStarted = true
            self.numberOfPages = cellsVMs.count
        }.whenFailed { [weak self] error in
            guard let self = self else { return }
            self.shimmer = false
            self.carouselStarted = false
            self.numberOfPages = 0
            print("ERROR: \(error.localizedDescription)")
            //TODO: show error
        }
    }
    
    override func updateModel() {
        shimmer = true
        headlineRepo.getModel()
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

extension HeadlineMoviesCellVM: HeadlineMoviesCellObserver {
    func headlineMovieCell(_ cell: HeadlineMoviesCell, didTapCellAt indexPath: IndexPath) {
        guard let currentModels = headlineRepo.currentModel,
            let model = currentModels[safe: indexPath.item] else { return }
        onTapHeadline?(model)
    }
    
    func headlineMovieCell(_ cell: HeadlineMoviesCell, didScrolledTo indexPath: IndexPath) {
        page = indexPath.item
    }
}

// MARK: Collection Data Source

extension HeadlineMoviesCellVM: UICollectionViewDataSource {
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

// MARK: Model Repo

class HeadlineMoviesRepo: ModelRepository<[MovieResults.Result], Void> {
    lazy var apiManager: DiscoverAPIManager = DiscoverAPI.instance
    
    override func getModel(byParam param: Void) {
        apiManager.discover().then(run: { [weak self] result in
            guard let parsed = result.parsedResponse else {
                self?.signalError(with: APIError(description: "No Result"))
                return
            }
            self?.currentModel = Array(parsed.results.prefix(through: 5))
            self?.signalSuccess(with: self?.currentModel ?? [])
        }, whenFailed: { [weak self] error in
            self?.signalError(with: error)
        })
    }
}
