//
//  UIEdgeInsets+Extensions.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

public extension UIEdgeInsets {
    init(insets: CGFloat) {
        self.init(top: insets, left: insets, bottom: insets, right: insets)
    }
}
