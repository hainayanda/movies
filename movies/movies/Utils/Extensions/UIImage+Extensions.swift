//
//  UIImage+Extension.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

public extension UIImage {
    static var starIcon: UIImage {
        return #imageLiteral(resourceName: "ic_star")
    }
    
    static var timerIcon: UIImage {
        return #imageLiteral(resourceName: "ic_timer")
    }
    
    static var play: UIImage {
        return #imageLiteral(resourceName: "play")
    }
    
    static var pause: UIImage {
        return #imageLiteral(resourceName: "pause")
    }
    static var placeHolder: UIImage? {
        return UIImage(color: .silver)
    }
}

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
