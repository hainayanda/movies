//
//  MovieCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class MovieCell: UICollectionViewCell, CellComponent {
    typealias Observer = Void
    
    static var reuseIdentifier: String = "movie_cell"
    
    lazy var posterContainer: UIView = .init()
    lazy var poster: UIImageView = .init()
    lazy var title: UILabel = .init()
    lazy var genres: UILabel = .init()
    
    override func prepareForReuse() {
        poster.image = .placeHolder
        title.text = nil
        genres.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        makeSubviewsConstraints()
        setupPoster()
        setupTitle()
        setupGenres()
    }
    
    private func makeSubviewsConstraints() {
        contentView.addSubview(posterContainer)
        posterContainer.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(9)
            make.top.equalToSuperview().inset(18)
        }
        posterContainer.addSubview(poster)
        poster.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(title)
        title.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(9)
            make.top.equalTo(poster.snp.bottom).offset(9)
            make.height.equalTo(17)
        }
        contentView.addSubview(genres)
        genres.snp.remakeConstraints { make in
            make.left.bottom.right.equalToSuperview().inset(9)
            make.top.equalTo(title.snp.bottom).offset(4.5)
            make.bottom.equalToSuperview().offset(18)
            make.height.equalTo(14.5)
        }
    }
    
    private func setupPoster() {
        poster.layer.cornerRadius = 9
        poster.layer.masksToBounds = true
        posterContainer.addDropShadow(at: .bottom)
        poster.contentMode = .scaleAspectFill
    }
    
    private func setupTitle() {
        title.font = .boldSystemFont(ofSize: 14)
        title.textColor = .black
        title.lineBreakMode = .byTruncatingTail
        title.numberOfLines = 1
    }
    
    private func setupGenres() {
        genres.font = .systemFont(ofSize: 12)
        genres.textColor = .gray
        title.lineBreakMode = .byTruncatingTail
        genres.numberOfLines = 1
    }
}

// MARK: View Model

class MovieCellVM: ViewModel<MovieCell> {
    @ViewModelBindable
    var posterImage: ImageCompatible?
    
    @ViewModelBindable
    var title: String?
    
    @ViewModelBindable
    var genres: [String] = []
    
    override func bind(view: MovieCell) {
        $posterImage.whenSet(view.poster) { poster, image in
            poster.imageCompat = image
        }.whenCompare { $0.equal(to: $1) }
        
        $title.whenSet(view.title) { label, title in
            label.text = title
        }.equalComparation()
        
        $genres.whenSet(view.genres) { label, genres in
            label.text = genres.joined(separator: ", ")
            
        }.equalComparation()
        
        updateView()
    }
}
