//
//  BackdropCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class BackdropCell: UICollectionViewCell, CellComponent {
    typealias Observer = Void
    
    static var reuseIdentifier: String = "backdrop_cell"
    
    lazy var backdropContainer: UIView = .init()
    lazy var backdrop: UIImageView = .init()
    
    override func prepareForReuse() {
        backdrop.image = .placeHolder
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupBackdrop()
        makeSubviewsConstraints()
    }
    
    private func makeSubviewsConstraints() {
        contentView.addSubview(backdropContainer)
        backdropContainer.snp.remakeConstraints { make in
            make.bottom.top.equalToSuperview().inset(9)
            make.left.right.equalToSuperview().inset(18)
        }
        backdropContainer.addSubview(backdrop)
        backdrop.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBackdrop() {
        backdrop.layer.cornerRadius = 18
        backdrop.clipsToBounds = true
        backdropContainer.addDropShadow(at: .bottom)
        backdrop.contentMode = .scaleAspectFill
    }
    
    
}

class BackdropCellVM: ViewModel<BackdropCell> {
    @ViewModelBindable
    var backdropImage: ImageCompatible?
    
    override func bind(view: BackdropCell) {
        $backdropImage.whenSet(view.backdrop) { backDrop, image in
            backDrop.imageCompat = image
        }.whenCompare { $0.equal(to: $1) }
        
        updateView()
    }
}
