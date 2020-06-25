//
//  ReviewCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class ReviewCell: UITableViewCell, CellComponent {
    typealias Observer = Void
    
    static var reuseIdentifier: String = "review_cell"
    
    lazy var author: UILabel = .init()
    lazy var review: UILabel = .init()
    
    override func prepareForReuse() {
        author.text = nil
        review.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        contentView.backgroundColor = .white
        setupAuthor()
        setupReview()
        makeSubViewsConstraints()
    }
    
    private func setupAuthor() {
        author.lineBreakMode = .byTruncatingTail
        author.font = .boldSystemFont(ofSize: 16)
        author.textColor = .black
        author.numberOfLines = 1
    }
    
    private func setupReview() {
        review.font = .systemFont(ofSize: 15, weight: .light)
        review.textColor = .gray
        review.numberOfLines = 0
    }
    
    private func makeSubViewsConstraints() {
        contentView.addSubview(author)
        author.snp.remakeConstraints { make in
            make.left.right.top.equalToSuperview().inset(18)
            make.height.greaterThanOrEqualTo(20)
        }
        contentView.addSubview(review)
        review.snp.remakeConstraints { make in
            make.top.equalTo(author.snp.bottom).offset(9)
            make.left.right.bottom.equalToSuperview().inset(18)
        }
    }
}

// MARK: View Model

class ReviewCellVM: ViewModel<ReviewCell> {
    @ViewModelBindable
    var author: String = ""
    
    @ViewModelBindable
    var review: String = ""
    
    override func bind(view: ReviewCell) {
        $author.whenSet(view.author) { label, text in
            label.text = text
        }.equalComparation()
        
        $review.whenSet(view.review) { label, text in
            label.text = text
        }.equalComparation()
        
        updateView()
    }
    
}
