//
//  GenreCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class GenreCell: UICollectionViewCell, CellComponent {
    typealias Observer = Void
    
    static var reuseIdentifier: String = "genre_cell"
    
    lazy var card: UIView = .init()
    lazy var label: UILabel = .init()
    
    override func prepareForReuse() {
        card.backgroundColor = nil
        label.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupLabel()
        
        contentView.addSubview(card)
        card.frame = contentView.bounds.marginedBy(insets: .init(insets: 9))
        card.layer.cornerRadius = 18
        card.addDropShadow(at: .bottom)
        card.addSubview(label)
        label.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupLabel() {
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.textColor = .white
    }
}

class GenreCellVM: ViewModel<GenreCell> {
    @ViewModelBindable
    var color: UIColor = .black
    
    @ViewModelBindable
    var genre: String = ""
    
    override func bind(view: GenreCell) {
        $color.whenSet(view.card) { card, color in
            card.backgroundColor = color
        }.equalComparation()
        
        $genre.whenSet(view.label) { label, genre in
            label.text = genre
        }.equalComparation()
        
        updateView()
    }
}
