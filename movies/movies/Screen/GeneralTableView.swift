//
//  GeneralTableView.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import UIKit
import SkeletonView

class GeneralTableView: UIViewController, ViewComponent {
    typealias Observer = GeneralTableViewObserver
    
    var observer: GeneralTableViewObserver?
    
    lazy var tableView: UITableView = .init()
    lazy var refreshControl: UIRefreshControl = .init()
    lazy var navTitle: UILabel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupTable()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.backgroundColor = .white
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .alizarin
        navigationController?.navigationBar.isTranslucent = false
        
        navTitle.font = .systemFont(ofSize: 27, weight: .black)
        navTitle.textAlignment = .center
        navTitle.textColor = .alizarin
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 22))
        container.addSubview(navTitle)
        
        let leftButtonWidth: CGFloat = 56
        let rightButtonWidth: CGFloat = 56
        let width = view.frame.width - leftButtonWidth - rightButtonWidth
        let offset = -((rightButtonWidth - leftButtonWidth) / 2)
        
        navTitle.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview().offset(offset)
            make.width.equalTo(width)
        }
        navigationItem.titleView = container
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupTable() {
        tableView.backgroundColor = .white
        tableView.contentInset = view.safeAreaInsets
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func didPullToRefresh() {
        observer?.generalTableView(self, didPullToRefresh: refreshControl)
    }
}

protocol GeneralTableViewObserver {
    func generalTableView(_ view: GeneralTableView, didPullToRefresh refreshControl: UIRefreshControl)
}
