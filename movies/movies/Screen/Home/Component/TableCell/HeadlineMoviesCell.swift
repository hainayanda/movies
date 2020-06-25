//
//  HeadlineMoviesCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HeadlineMoviesCell: UITableViewCell, CalculatedTableCellComponent {
    typealias Observer = HeadlineMoviesCellObserver
    
    static var reuseIdentifier: String = "headline_movies_cell"
    
    static func preferedHeight(for table: UITableView, at indexPath: IndexPath) -> CGFloat {
        return table.frame.width * 0.54
    }
    
    lazy var collectionLayout: UICollectionViewFlowLayout = .init()
    lazy var collectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: collectionLayout
    )
    lazy var pageControl: UIPageControl = .init()
    
    var observer: HeadlineMoviesCellObserver?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        backgroundColor = .white
        setupCollection()
        makeSubViewsConstraints()
    }
    
    private func setupPageControl() {
        pageControl.tintColor = .white
        pageControl.pageIndicatorTintColor = .darkGray
        pageControl.currentPageIndicatorTintColor = .white
    }
    
    private func setupCollection() {
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: 9, left: 0, bottom: 9, right: 0)
        collectionView.delegate = self
        
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.itemSize = contentView.frame.size
    }
    
    private func makeSubViewsConstraints() {
        contentView.addSubview(collectionView)
        collectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(pageControl)
        pageControl.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(27)
            make.height.equalTo(9)
        }
    }
}

// MARK: Collection Delegate

extension HeadlineMoviesCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        observer?.headlineMovieCell(self, didTapCellAt: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleCells = collectionView.visibleCells
        let centerX = scrollView.center.x
        var distanceToCenter: CGFloat = .infinity
        var centeredCell: UICollectionViewCell?
        for visibleCell in visibleCells {
            let distance = abs(centerX - visibleCell.center.x)
            if distance <= distanceToCenter {
                distanceToCenter = distance
                centeredCell = visibleCell
            }
        }
        guard let cell = centeredCell,
            let index = collectionView.indexPath(for: cell) else { return }
        observer?.headlineMovieCell(self, didScrolledTo: index)
    }
}

// MARK: View Observer Protocol

protocol HeadlineMoviesCellObserver {
    func headlineMovieCell(_ cell: HeadlineMoviesCell, didTapCellAt indexPath: IndexPath)
    func headlineMovieCell(_ cell: HeadlineMoviesCell, didScrolledTo indexPath: IndexPath)
}
