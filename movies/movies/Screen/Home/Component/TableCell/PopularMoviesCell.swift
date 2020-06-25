//
//  PopularMovieCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class PopularMoviesCell: UITableViewCell, CalculatedTableCellComponent {
    typealias Observer = PopularMoviesCellObserver
    static var reuseIdentifier: String = "popular_movies_cell"
    static func preferedHeight(for table: UITableView, at indexPath: IndexPath) -> CGFloat {
        return 261
    }
    
    lazy var collectionLayout: UICollectionViewFlowLayout = .init()
    lazy var collectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: collectionLayout
    )
    
    var observer: PopularMoviesCellObserver?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        backgroundColor = .white
        setupCollectionView()
        
        collectionLayout.itemSize = .init(
            width: contentView.frame.size.height * 0.54,
            height: contentView.frame.size.height
        )
        contentView.addSubview(collectionView)
        collectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: 4.5, left: 9, bottom: 4.5, right: 9)
        
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
    }
}

// MARK: Collection Delegate

extension PopularMoviesCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        observer?.popularMovieCell(self, didTapCellAt: indexPath)
    }
}

// MARK: View Observer Protocol

protocol PopularMoviesCellObserver {
    func popularMovieCell(_ cell: PopularMoviesCell, didTapCellAt indexPath: IndexPath)
}
