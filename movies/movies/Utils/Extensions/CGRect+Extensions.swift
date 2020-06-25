//
//  CGRect+Extensions.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

public extension CGRect {
    func marginedBy(insets: UIEdgeInsets) -> CGRect {
        let newSize: CGSize = .init(
            width: width - insets.left - insets.right,
            height: height - insets.top - insets.bottom
        )
        let newPosition: CGPoint = .init(
            x: self.origin.x + insets.left,
            y: self.origin.y + insets.top
        )
        return .init(origin: newPosition, size: newSize)
    }
}
