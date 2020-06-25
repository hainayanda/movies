//
//  SectionWithButton.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

class SectionWithButton: UIView, ViewComponent {
    typealias Observer = SectionWithButtonObserver
    
    var observer: SectionWithButtonObserver?
    
    lazy var label: UILabel = .init()
    lazy var button: UIButton = .init()
    
    @objc func onTapButton() {
        observer?.sectionWithButtonDidTapButton(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .white
        makeSubViewsConstraints()
        setupLabel()
        setupButton()
        addDropShadow(at: .bottom)
    }
    
    private func setupLabel() {
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
    }
    
    private func setupButton() {
        button.backgroundColor = .clear
        button.setTitleColor(.turquoise, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.titleLabel?.textAlignment = .right
        button.addTarget(self, action: #selector(onTapButton), for: .touchUpInside)
    }
    
    private func makeSubViewsConstraints() {
        addSubview(label)
        label.snp.remakeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(18)
        }
        addSubview(button)
        button.snp.remakeConstraints { make in
            make.right.top.bottom.equalToSuperview().inset(18)
            make.width.greaterThanOrEqualTo(72)
        }
    }
}

protocol SectionWithButtonObserver {
    func sectionWithButtonDidTapButton(_ view: SectionWithButton)
}

// MARK: View Model

class SectionWithButtonVM: ViewModel<SectionWithButton> {
    
    @ViewModelBindable
    var title: String = ""
    
    @ViewModelBindable
    var buttonTitle: String = ""
    
    var onTap: ((SectionWithButton) -> Void)?
    
    override func bind(view: SectionWithButton) {
        view.observer = self
        $title.whenSet(view.label) { label, text in
            label.text = text
        }.equalComparation()
        
        $buttonTitle.whenSet(view.button) { button, title in
            button.setTitle(title, for: .normal)
        }.equalComparation()
        
        updateView()
    }
}

extension SectionWithButtonVM: SectionWithButtonObserver {
    func sectionWithButtonDidTapButton(_ view: SectionWithButton) {
        onTap?(view)
    }
}
