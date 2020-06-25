//
//  ViewComponent.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

protocol ViewComponent {
    associatedtype Observer
    var observer: Observer? { get set }
}

protocol CellComponent: ViewComponent {
    static var reuseIdentifier: String { get }
}

protocol CalculatedTableCellComponent: CellComponent {
    static func preferedHeight(for table: UITableView, at indexPath: IndexPath) -> CGFloat
}

protocol CalculatedCollectionCellComponent: CellComponent {
    static func preferedSize(for collection: UICollectionView, at indexPath: IndexPath) -> CGSize
}

extension ViewComponent where Observer == Void {
    var observer: Observer? {
        get { nil }
        set { }
    }
}
