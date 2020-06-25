//
//  ImageCompatible.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import Nuke

public extension UIImageView {
    var imageCompat: ImageCompatible? {
        get { return image }
        set {
            guard let imageCompat = newValue else {
                self.image = nil
                return
            }
            imageCompat.loadInto(imageView: self)
        }
    }
}

public protocol ImageCompatible {
    func loadInto(imageView: UIImageView)
    func equal(to other: ImageCompatible) -> Bool
}

extension Optional where Wrapped == ImageCompatible {
    public func equal(to other: ImageCompatible?) -> Bool {
        guard let wrapped = self, let otherImage = other else {
            return self == nil && other == nil
        }
        return wrapped.equal(to: otherImage)
    }
}

extension UIImage: ImageCompatible {
    public func loadInto(imageView: UIImageView) {
        runOnMainThread { [weak self, weak imageView = imageView] in
            guard let self = self, let imageView = imageView else { return }
            imageView.image = self
        }
    }
    
    public func equal(to other: ImageCompatible) -> Bool {
        guard let otherImage = other as? UIImage else { return false }
        return otherImage == self
    }
}

extension URL: ImageCompatible {
    
    public func loadInto(imageView: UIImageView) {
        let options = ImageLoadingOptions(
            placeholder: .placeHolder,
            transition: .fadeIn(duration: 0.27)
        )
        Nuke.loadImage(with: self, options: options, into: imageView)
    }
    
    public func equal(to other: ImageCompatible) -> Bool {
        guard let otherURL = other as? URL else { return false }
        return otherURL == self
    }
}

extension String: ImageCompatible {
    public func loadInto(imageView: UIImageView) {
        guard let url = URL(string: self) else { return }
        url.loadInto(imageView: imageView)
    }
    
    public func equal(to other: ImageCompatible) -> Bool {
        guard let otherString = other as? String else { return false }
        return otherString == self
    }
}

