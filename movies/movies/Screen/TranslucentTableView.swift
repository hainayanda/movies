//
//  TranslucentTableView.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import SkeletonView
import UIKit

class TranslucentTableView: UIViewController, ViewComponent {
    typealias Observer = TranslucentTableViewObserver
    
    var observer: TranslucentTableViewObserver?
    
    lazy var tableView: UITableView = .init()
    lazy var refreshControl: UIRefreshControl = .init()
    lazy var navTitle: UILabel = .init()
    lazy var translucentBackDrop: UIImageView = .init()
    lazy var statusBarView: UIView = .init()
    lazy var blurEffect = UIBlurEffect(style:  .dark)
    lazy var blurEffectView = UIVisualEffectView(effect: blurEffect)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTable()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        view.backgroundColor = .white
        translucentBackDrop.contentMode = .scaleAspectFill
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        
        view.addSubview(translucentBackDrop)
        view.sendSubviewToBack(translucentBackDrop)
        translucentBackDrop.layer.masksToBounds = true
        translucentBackDrop.frame = .init(
            origin: .zero,
            size: .init(width: view.frame.width, height: view.frame.width)
        )
        blurEffectView.frame = translucentBackDrop.bounds
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        translucentBackDrop.addSubview(blurEffectView)
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = .alizarin
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        statusBarView.backgroundColor = .white
        statusBarView.alpha = 0

        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        view.addSubview(statusBarView)
        statusBarView.frame = window?.windowScene?.statusBarManager?.statusBarFrame ??
            CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setNavbar(backgroundColorAlpha alpha: CGFloat) {
        let color = UIColor.white.withAlphaComponent(alpha)
        navigationController?.navigationBar.backgroundColor = color
        statusBarView.alpha = alpha
        blurEffectView.alpha = 0.8 + (alpha * 0.2)
    }
    
    private func setupTable() {
        tableView.backgroundColor = .clear
        tableView.contentInset = view.safeAreaInsets
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.addSubview(translucentBackDrop)
        translucentBackDrop.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(translucentBackDrop.snp.width)
        }
    }
    
    @objc func didPullToRefresh() {
        observer?.translucentTableView(self, didPullToRefresh: refreshControl)
    }
}

protocol TranslucentTableViewObserver {
    func translucentTableView(_ view: TranslucentTableView, didPullToRefresh refreshControl: UIRefreshControl)
}
