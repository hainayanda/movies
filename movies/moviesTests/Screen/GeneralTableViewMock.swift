//
//  GeneralTableViewMock.swift
//  moviesTests
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

@testable import movies

class GeneralTableViewMock: GeneralTableView {
    func mimicPullToRefresh() {
        refreshControl.beginRefreshing()
        didPullToRefresh()
    }
    
    func mimicScroll(to indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
    }
    
    func mimicSelect(at indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
}
