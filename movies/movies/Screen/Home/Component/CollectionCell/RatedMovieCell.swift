//
//  RatedMovieCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class RatedMovieCell: UICollectionViewCell, CellComponent {
    typealias Observer = Void
    
    static var reuseIdentifier: String = "rated_movie_cell"
    
    lazy var posterContainer: UIView = .init()
    lazy var poster: UIImageView = .init()
    lazy var title: UILabel = .init()
    lazy var star: UIImageView = .init()
    lazy var rating: UILabel = .init()
    
    override func prepareForReuse() {
        poster.image = .placeHolder
        title.text = nil
        rating.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        makeSubviewsConstraints()
        star.image = .starIcon
        star.contentMode = .scaleAspectFit
        setupTitle()
        setupRating()
        setupPoster()
    }
    
    func makeSubviewsConstraints() {
        contentView.addSubview(posterContainer)
        posterContainer.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview().inset(9)
        }
        posterContainer.addSubview(poster)
        poster.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(title)
        title.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(9)
            make.top.equalTo(poster.snp.bottom).offset(9)
            make.height.greaterThanOrEqualTo(17)
        }
        contentView.addSubview(star)
        star.snp.remakeConstraints { make in
            make.height.width.equalTo(18)
            make.left.bottom.equalToSuperview().inset(9)
            make.top.equalTo(title.snp.bottom).offset(9)
        }
        contentView.addSubview(rating)
        rating.snp.remakeConstraints { make in
            make.centerY.equalTo(star.snp.centerY)
            make.left.equalTo(star.snp.right).offset(4.5)
        }
    }
    
    private func setupPoster() {
        poster.layer.cornerRadius = 9
        poster.layer.masksToBounds = true
        posterContainer.addDropShadow(at: .bottom)
        poster.contentMode = .scaleAspectFill
    }
    
    private func setupTitle() {
        title.font = .boldSystemFont(ofSize: 16)
        title.textColor = .black
        title.lineBreakMode = .byTruncatingTail
        title.numberOfLines = 1
    }
    
    private func setupRating() {
        rating.font = .systemFont(ofSize: 14)
        rating.textColor = .gray
        rating.numberOfLines = 1
    }
}

class RatedMovieCellVM: ViewModel<RatedMovieCell> {
    @ViewModelBindable
    var posterImage: ImageCompatible?
    
    @ViewModelBindable
    var title: String?
    
    @ViewModelBindable
    var rate: Double?
    
    override func bind(view: RatedMovieCell) {
        $posterImage.whenSet(view.poster) { poster, image in
            poster.imageCompat = image
        }.whenCompare { $0.equal(to: $1) }
        
        $title.whenSet(view.title) { label, title in
            label.text = title
        }.equalComparation()
        
        $rate.whenSet(view.rating) { label, rating in
            guard let rating = rating else {
                label.text = nil
                return
            }
            label.text = "\(rating)"
        }.equalComparation()
        
        updateView()
    }
}
