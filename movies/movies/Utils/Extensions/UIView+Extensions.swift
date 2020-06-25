//
//  UIView+Extensions.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

// MARK: Shadow

public extension UIView {
    
    enum DropShadowDirection {
        case top
        case bottom
        case center
    }
    
    func removeDropShadow() {
        layer.shadowColor = UIColor.clear.cgColor
    }
    
    func addDropShadow(at direction: DropShadowDirection) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.09
        layer.shadowRadius = 4.5
        layer.masksToBounds = false
        switch direction {
        case .top:
            layer.shadowOffset = .init(width: 0, height: -2)
        case .bottom:
            layer.shadowOffset = .init(width: 0, height: 2)
        default:
            layer.shadowOffset = .zero
        }
    }
}

// MARK: Shimmer

@objc public protocol ShimmerView {
    func showShimmer()
    func hideShimmer()
}

extension UIView: ShimmerView {
    @objc public func showShimmer() {
        isSkeletonable = true
        runOnMainThread { [weak self] in
            guard let self = self else { return }
            let animation = GradientDirection.leftRight.slidingAnimation(duration: 0.9)
            let gradient = SkeletonGradient(
                baseColor: UIColor.clouds,
                secondaryColor: UIColor.silver
            )
            self.showAnimatedGradientSkeleton(
                usingGradient: gradient,
                animation: animation,
                transition: .none
            )
        }
    }
    
    @objc public func hideShimmer() {
        runOnMainThread { [weak self] in
            guard let self = self else { return }
            self.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.18))
        }
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
