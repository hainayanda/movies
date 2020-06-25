//
//  MoviesCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class MoviesCell: UITableViewCell, CalculatedTableCellComponent {
    typealias Observer = MoviesCellObserver
    static var reuseIdentifier: String = "movies_cell"
    static func preferedHeight(for table: UITableView, at indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    lazy var collectionLayout: UICollectionViewFlowLayout = .init()
    lazy var collectionView: UICollectionView = .init(
        frame: .zero,
        collectionViewLayout: collectionLayout
    )
    
    var observer: MoviesCellObserver?
    
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

extension MoviesCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        observer?.movieCell(self, didTapCellAt: indexPath)
    }
}

// MARK: View Observer Protocol

protocol MoviesCellObserver {
    func movieCell(_ cell: MoviesCell, didTapCellAt indexPath: IndexPath)
}
