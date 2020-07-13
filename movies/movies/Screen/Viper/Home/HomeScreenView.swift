//
//  HomeScreenView.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 13/07/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class HomeScreenView: GeneralTableView {
    var presenter: HomePresenter? {
        didSet {
            presenter?.didNeedReload()
        }
    }
    
    var navigationTitle: String? {
        get {
            navTitle.text
        }
        set {
            navTitle.text = newValue
        }
    }
    
    lazy var headlineCell: HeadlineMoviesCellComponentVM = .init()
    lazy var popularCell: PopularMoviesCellComponentVM = .init()
    lazy var newMovieCell: MoviesCellComponentVM = .init()
    lazy var comingSoonCell: MoviesCellComponentVM = .init()
    lazy var genresCell: GenresCellComponentVM = .init()
    
    private var heightCalculators: [(UITableView, IndexPath) -> CGFloat] = [
        HeadlineMoviesCell.preferedHeight, PopularMoviesCell.preferedHeight,
        GenresCell.preferedHeight, MoviesCell.preferedHeight,
        MoviesCell.preferedHeight
    ]
    
    private var sectionsVM: [SectionWithButtonVM?] = [
        nil, .init(), .init(), .init(), .init()
    ]
    
    override func didPullToRefresh() {
        presenter?.didNeedReload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didNeedReload()
        setupTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupTable() {
        tableView.register(HeadlineMoviesCell.self, forCellReuseIdentifier: HeadlineMoviesCell.reuseIdentifier)
        tableView.register(PopularMoviesCell.self, forCellReuseIdentifier: PopularMoviesCell.reuseIdentifier)
        tableView.register(GenresCell.self, forCellReuseIdentifier: GenresCell.reuseIdentifier)
        tableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension HomeScreenView: HomeView {
    func shimmer(section: HomeScreenSection) {
        switch section {
        case .headline:
            headlineCell.shimmer = true
        case .popular:
            popularCell.shimmer = true
        case .new:
            newMovieCell.shimmer = true
        case .soon:
            comingSoonCell.shimmer = true
        case .genre:
            genresCell.shimmer = true
        }
    }
    
    func showHeadline(from results: [BackdropCellVM]) {
        headlineCell.shimmer = false
        headlineCell.cellsVMs = results
        headlineCell.numberOfPages = results.count
        headlineCell.page = 0
        tableView.reloadData()
    }
    
    func showPopular(from results: [RatedMovieCellVM]) {
        popularCell.shimmer = false
        popularCell.cellsVMs = results
        tableView.reloadData()
    }
    
    func showNewest(from results: [MovieCellVM]) {
        newMovieCell.shimmer = false
        newMovieCell.cellsVMs = results
        tableView.reloadData()
    }
    
    func showComingSoon(from results: [MovieCellVM]) {
        comingSoonCell.shimmer = false
        comingSoonCell.cellsVMs = results
        tableView.reloadData()
    }
    
    func showGenres(from results: [GenreCellVM]) {
        genresCell.shimmer = false
        genresCell.cellsVMs = results
        tableView.reloadData()
    }
    
    func hideRefreshControl() {
        refreshControl.endRefreshing()
    }
}



// MARK: UITableView DataSource and Delegate

extension HomeScreenView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            headlineCell.onTapHeadline = { [weak self] headline in
                self?.presenter?.didTapHeadline(movieCell: headline)
            }
            return bind(viewModel: headlineCell, forTable: tableView, at: indexPath)
        case 1:
            popularCell.onTapMovies = { [weak self] popular in
                self?.presenter?.didTapPopular(movieCell: popular)
            }
            return bind(viewModel: popularCell, forTable: tableView, at: indexPath)
        case 2:
            genresCell.onTapGenre = { [weak self] genre in
                self?.presenter?.didTap(genreCell: genre)
            }
            return bind(viewModel: genresCell, forTable: tableView, at: indexPath)
        case 3:
            newMovieCell.onTapMovies = { [weak self] new in
                self?.presenter?.didTapNew(movieCell: new)
            }
            return bind(viewModel: newMovieCell, forTable: tableView, at: indexPath)
        case 4:
            comingSoonCell.onTapMovies = { [weak self] soon in
                self?.presenter?.didTapComingSoon(movieCell: soon)
            }
            return bind(viewModel: comingSoonCell, forTable: tableView, at: indexPath)
        default:
            return .init()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { 5 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let homeSection = HomeScreenSection(rawValue: section),
            let title = presenter?.sectionTitles(for: homeSection),
            let optionalVM = sectionsVM[safe: section],
            let viewModel = optionalVM else {
                return nil
        }
        let view = SectionWithButton()
        viewModel.bind(view: view)
        viewModel.title = title
        viewModel.buttonTitle = section == 2 ? "" : "Show all"
        viewModel.onTap = { [weak self] _ in
            guard let self = self else { return }
            switch section {
            case 1:
                self.presenter?.didTapAllPopularMovies()
            case 3:
                self.presenter?.didTapAllNewestMovies()
            case 4:
                self.presenter?.didTapAllComingSoonMovies()
            default:
                break
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 63
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCalculators[safe: indexPath.section]?(tableView, indexPath) ?? 0
    }
    
    private func bind<View: UITableViewCell, VModel: ViewModel<View>>(
        viewModel: VModel,
        forTable table: UITableView,
        at indexPath: IndexPath) -> UITableViewCell where View: CellComponent {
        guard let cell = table.dequeueReusableCell(withIdentifier: View.reuseIdentifier, for: indexPath) as? View else {
            return .init()
        }
        viewModel.bind(view: cell)
        return cell
    }
    
}

