//
//  MovieDetailHeaderCellVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class MovieDetailHeaderCellVM: ViewModel<MovieDetailHeaderCell> {
    @ViewModelBindable
    var posterImage: ImageCompatible?
    
    @ViewModelBindable
    var title: String?
    
    @ViewModelBindable
    var originalTitle: String?
    
    @ViewModelBindable
    var duration: Int = 0
    
    @ViewModelBindable
    var budget: Int = 0
    
    @ViewModelBindable
    var genres: [String] = []
    
    @ViewModelBindable
    var releaseDate: Date?
    
    @ViewModelBindable
    var rate: Double?
    
    @ViewModelBindable
    var story: String?
    
    @ViewModelBindable
    var shimmer: Bool = false
    
    override func bind(view: MovieDetailHeaderCell) {
        $story.whenSet(view.story) { label, text in
            label.text = text ?? "-"
        }.equalComparation()
        
        $posterImage.whenSet(view.poster) { poster, image in
            poster.imageCompat = image ?? UIImage.placeHolder
        }.whenCompare { $0.equal(to: $1) }
        
        $title.whenSet(view.title) { label, title in
            label.text = title
        }.equalComparation()
        
        $originalTitle.whenSet(view.originalTitle) { label, title in
            label.attributedText = Self.createAtttributedLabel(
                label: "Original Title",
                value: title ?? "-"
            )
        }.equalComparation()
        
        $genres.whenSet(view.genres) { label, genres in
            label.attributedText = Self.createAtttributedLabel(
                label: "Genres",
                value: genres.joined(separator: ", ")
            )
        }.equalComparation()
        
        $budget.whenSet(view.budget) { label, budget in
            guard budget < 0 else {
                label.attributedText = Self.createAtttributedLabel(
                    label: "Budget",
                    value: "unknown"
                )
                return
            }
            let budgetStr = String(format: "$%.02f", Double(budget))
            label.attributedText = Self.createAtttributedLabel(
                label: "Budget",
                value: budgetStr
            )
        }.equalComparation()
        $releaseDate.whenSet(view.releaseDate) { label, date in
            guard let date = date else {
                label.attributedText = Self.createAtttributedLabel(
                    label: "Release date",
                    value: "Unreleased"
                )
                return
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let dateStr = formatter.string(from: date)
            label.attributedText = Self.createAtttributedLabel(
                label: "Release date:",
                value: dateStr
            )
        }.equalComparation()
        
        $rate.whenSet(view.rating) { label, rating in
            guard let rating = rating else {
                label.text = nil
                return
            }
            label.text = "\(rating)"
        }.equalComparation()
        
        $duration.whenSet(view.duration) { label, duration in
            label.text = "\(duration) minutes"
        }
        
        $shimmer.whenSet(view.card) { card, shimmer in
            if shimmer {
                card.showShimmer()
            } else {
                card.hideShimmer()
            }
        }.equalComparation()
        
        updateView()
    }
    
    static func createAtttributedLabel(label: String, value: String) -> NSAttributedString {
        return NSAttributedString.startWithAttrs {
            $0.color = .black
            $0.font = .systemFont(ofSize: 14)
        }.text("\(label): ").nextAttrs {
            $0.color = .turquoise
            $0.font = .systemFont(ofSize: 14)
        }.text(value).build()
    }
}
