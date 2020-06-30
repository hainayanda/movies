//
//  UIViewController+Extensions.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

// MARK: Model

public class PopUp {
    public var title: String = ""
    public var message: String = ""
    
    public enum AlertStyle {
        case none
        case destructive
    }
    
    public class AlertModel: PopUp {
        public var style: AlertStyle = .none
        public var negativeButtonTitle: String = "No"
        public var positiveButtonTitle: String = "Yes"
        public var positiveHandler: ((UIAlertAction) -> Void)?
        public var negativeHandler: ((UIAlertAction) -> Void)?
    }

    public class OptionsModel: PopUp {
        public var actions: [UIAlertAction] = []
        
    }
}

// MARK: Alert & Options

public extension UIViewController {
    // MARK: Alert
    
    func showSystemAlert(builder: (PopUp.AlertModel) -> Void) {
        let model = PopUp.AlertModel()
        builder(model)
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert
        )
        alert.addAction(
            .init(
                title: model.positiveButtonTitle,
                style: .default,
                handler: model.positiveHandler
            )
        )
        alert.addAction(
            .init(
                title: model.negativeButtonTitle,
                style: model.style == .none ? .cancel : .destructive,
                handler: model.negativeHandler
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Options
    
    func showOptions(builder: (PopUp.OptionsModel) -> Void) {
        let model = PopUp.OptionsModel()
        builder(model)
        let options = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .actionSheet
        )
        for actions in model.actions {
            options.addAction(actions)
        }
        present(options, animated: true, completion: nil)
    }
    
    // MARK: Toast
    
    func showToast(message: String) {
        let toastContainer: UIView = .init()
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 27
        toastContainer.clipsToBounds  =  true

        let toastLabel: UILabel = .init()
        toastLabel.font = .systemFont(ofSize: 12)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        view.addSubview(toastContainer)
        toastContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(63)
            make.trailing.equalToSuperview().offset(-63)
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(54)
        }
        toastContainer.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
        }
        UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
