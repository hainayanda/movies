//
//  MovieListCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class MovieListCell: UITableViewCell, CalculatedTableCellComponent {
    
    typealias Observer = Void
    
    static func preferedHeight(for table: UITableView, at indexPath: IndexPath) -> CGFloat {
        return 162
    }
    
    static var reuseIdentifier: String = "movie_list_cell"
    
    lazy var posterContainer: UIView = .init()
    lazy var poster: UIImageView = .init()
    lazy var title: UILabel = .init()
    lazy var originalTitle: UILabel = .init()
    lazy var genres: UILabel = .init()
    lazy var releaseDate: UILabel = .init()
    lazy var star: UIImageView = .init()
    lazy var rating: UILabel = .init()
    
    override func prepareForReuse() {
        poster.image = .placeHolder
        title.text = nil
        originalTitle.text = nil
        genres.text = nil
        rating.text = nil
        releaseDate.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        makeSubviewsConstraints()
        star.image = .starIcon
        star.contentMode = .scaleAspectFit
        setupTitle()
        setupComplimentaryLabel(originalTitle)
        setupComplimentaryLabel(genres)
        setupComplimentaryLabel(releaseDate)
        setupRating()
        setupPoster()
    }
    
    func makeSubviewsConstraints() {
        contentView.addSubview(posterContainer)
        posterContainer.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(18)
            make.left.equalToSuperview().inset(18)
            make.width.equalTo(posterContainer.snp.height).multipliedBy(0.63)
        }
        posterContainer.addSubview(poster)
        poster.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(posterContainer.snp.right).offset(18)
            make.top.equalTo(posterContainer.snp.top)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5)
        }
        contentView.addSubview(originalTitle)
        originalTitle.snp.makeConstraints { make in
            make.left.equalTo(posterContainer.snp.right).offset(18)
            make.top.equalTo(title.snp.bottom).offset(4.5)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5)
            make.height.greaterThanOrEqualTo(18)
        }
        contentView.addSubview(releaseDate)
        releaseDate.snp.makeConstraints { make in
            make.left.equalTo(posterContainer.snp.right).offset(18)
            make.bottom.equalTo(posterContainer.snp.bottom)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.5)
            make.height.greaterThanOrEqualTo(18)
        }
        contentView.addSubview(genres)
        genres.snp.makeConstraints { make in
            make.left.equalTo(posterContainer.snp.right).offset(18)
            make.bottom.equalTo(releaseDate.snp.top).offset(-4.5)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            make.height.greaterThanOrEqualTo(18)
        }
        contentView.addSubview(rating)
        rating.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(18)
            make.centerY.equalTo(title.snp.centerY)
            make.width.greaterThanOrEqualTo(22.5)
        }
        contentView.addSubview(star)
        star.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(54)
            make.centerY.equalTo(title.snp.centerY)
            make.height.width.equalTo(18)
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
        title.numberOfLines = 2
    }
    
    private func setupRating() {
        rating.font = .systemFont(ofSize: 16)
        rating.textColor = .gray
        rating.numberOfLines = 1
    }
    
    private func setupComplimentaryLabel(_ label: UILabel) {
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
    }
}

class MovieListCellVM: ViewModel<MovieListCell> {
    @ViewModelBindable
    var posterImage: ImageCompatible?
    
    @ViewModelBindable
    var title: String?
    
    @ViewModelBindable
    var originalTitle: String?
    
    @ViewModelBindable
    var genres: [String] = []
    
    @ViewModelBindable
    var releaseDate: Date?
    
    @ViewModelBindable
    var rate: Double?
    
    override func bind(view: MovieListCell) {
        $posterImage.whenSet(view.poster) { poster, image in
            poster.imageCompat = image ?? UIImage.placeHolder
        }.whenCompare { $0.equal(to: $1) }
        
        $title.whenSet(view.title) { label, title in
            label.text = title
        }.equalComparation()
        
        $originalTitle.whenSet(view.originalTitle) { label, title in
            label.text = title
        }.equalComparation()
        
        $genres.whenSet(view.genres) { label, genres in
            label.text = genres.joined(separator: ", ")
        }.equalComparation()
        
        $releaseDate.whenSet(view.releaseDate) { label, date in
            guard let date = date else {
                label.text = nil
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            label.text = formatter.string(from: date)
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
