//
//  MovieDetailHeaderCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class MovieDetailHeaderCell: UITableViewCell, CellComponent {
    
    typealias Observer = Void
    
    static var reuseIdentifier: String = "movie_detail_header_cell"
    
    lazy var card: UIView = .init()
    lazy var posterContainer: UIView = .init()
    lazy var poster: UIImageView = .init()
    lazy var title: UILabel = .init()
    lazy var originalTitle: UILabel = .init()
    lazy var genres: UILabel = .init()
    lazy var releaseDate: UILabel = .init()
    lazy var star: UIImageView = .init()
    lazy var clock: UIImageView = .init()
    lazy var rating: UILabel = .init()
    lazy var duration: UILabel = .init()
    lazy var budget: UILabel = .init()
    lazy var storyLabel: UILabel = .init()
    lazy var story: UILabel = .init()
    
    override func prepareForReuse() {
        poster.image = .placeHolder
        title.text = nil
        originalTitle.text = nil
        genres.text = nil
        rating.text = nil
        releaseDate.text = nil
        budget.text = nil
        budget.attributedText = nil
        duration.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        card.backgroundColor = .white
        card.addDropShadow(at: .top)
        makeSubviewsConstraints()
        star.image = .starIcon
        star.contentMode = .scaleAspectFit
        clock.image = .timerIcon
        clock.contentMode = .scaleAspectFit
        setupTitle()
        setupComplimentaryLabel(originalTitle)
        setupComplimentaryLabel(genres)
        setupComplimentaryLabel(releaseDate)
        setupComplimentaryLabel(budget)
        setupRating()
        setupDuration()
        setupPoster()
        setupStoryLabels()
    }
    
    func makeSubviewsConstraints() {
        contentView.addSubview(card)
        card.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(144)
            make.left.right.bottom.equalToSuperview()
        }
        contentView.addSubview(posterContainer)
        posterContainer.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(63)
            make.left.equalToSuperview().inset(18)
            make.height.equalTo(180)
            make.width.equalTo(posterContainer.snp.height).multipliedBy(0.63)
        }
        posterContainer.addSubview(poster)
        poster.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        card.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(posterContainer.snp.right).offset(18)
            make.right.lessThanOrEqualToSuperview().inset(18)
            make.top.equalToSuperview().offset(18)
        }
        card.addSubview(star)
        star.snp.remakeConstraints { make in
            make.height.width.equalTo(18)
            make.left.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(4.5)
        }
        card.addSubview(rating)
        rating.snp.remakeConstraints { make in
            make.left.equalTo(star.snp.right).offset(9)
            make.centerY.equalTo(star)
        }
        card.addSubview(clock)
        clock.snp.remakeConstraints { make in
            make.left.equalTo(rating.snp.right).offset(18)
            make.centerY.equalTo(star)
            make.height.width.equalTo(18)
        }
        card.addSubview(duration)
        duration.snp.remakeConstraints { make in
            make.left.equalTo(clock.snp.right).offset(9)
            make.centerY.equalTo(clock)
            make.right.lessThanOrEqualToSuperview().inset(18)
        }
        card.addSubview(originalTitle)
        originalTitle.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalTo(posterContainer.snp.bottom).offset(27)
            make.right.lessThanOrEqualToSuperview().inset(18)
        }
        card.addSubview(genres)
        genres.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalTo(originalTitle.snp.bottom).offset(9)
            make.right.lessThanOrEqualToSuperview().inset(18)
        }
        card.addSubview(releaseDate)
        releaseDate.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalTo(genres.snp.bottom).offset(9)
            make.right.lessThanOrEqualToSuperview().inset(18)
        }
        card.addSubview(budget)
        budget.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalTo(releaseDate.snp.bottom).offset(9)
            make.right.lessThanOrEqualToSuperview().inset(18)
        }
        card.addSubview(storyLabel)
        storyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalTo(budget.snp.bottom).offset(18)
            make.right.lessThanOrEqualToSuperview().inset(18)
        }
        card.addSubview(story)
        story.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalTo(storyLabel.snp.bottom).offset(18)
            make.right.lessThanOrEqualToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(18)
        }
    }
    
    private func setupPoster() {
        poster.layer.cornerRadius = 9
        poster.layer.masksToBounds = true
        posterContainer.addDropShadow(at: .bottom)
        poster.contentMode = .scaleAspectFill
    }
    
    private func setupTitle() {
        title.font = .boldSystemFont(ofSize: 17)
        title.textColor = .black
        title.lineBreakMode = .byTruncatingTail
        title.numberOfLines = 3
    }
    
    private func setupRating() {
        rating.font = .systemFont(ofSize: 15)
        rating.textColor = .gray
        rating.numberOfLines = 1
    }
    
    private func setupStoryLabels() {
        storyLabel.font = .boldSystemFont(ofSize: 17)
        storyLabel.textColor = .black
        storyLabel.numberOfLines = 1
        storyLabel.text = "STORYLINE"
        
        story.font = .systemFont(ofSize: 15)
        story.textColor = .gray
        story.numberOfLines = 0
    }
    
    private func setupDuration() {
        duration.font = .systemFont(ofSize: 15)
        duration.textColor = .gray
        duration.numberOfLines = 1
    }
    
    private func setupComplimentaryLabel(_ label: UILabel) {
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
    }
}
