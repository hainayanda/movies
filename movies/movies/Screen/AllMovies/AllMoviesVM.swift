//
//  AllMoviesViewModel.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import SkeletonView

class AllMoviesVM: ScreenViewModel<GeneralTableView> {
    @ViewModelBindable
    var navigationTitle: String?
    
    @ViewModelBindable
    var moviesCellsVM: [MovieListCellVM] = []
    
    var genresMap: [Int: String] = [:] {
        didSet {
            reloadAll()
        }
    }
    
    lazy var router: GeneralRouterProtocol = GeneralRouter.shared
    
    private var loadPage: Bool = false
    private var noMorePage: Bool = false
    
    // MARK: Injected Repositoriy
    var movieRepo: ModelRepository<[MovieResults.Result], InfiniteParam>? {
        didSet {
            bindToModelRepositories()
            reloadAll()
        }
    }
    
    lazy var genresRepo: ModelRepository<[MovieGenres.Genre], Void> = GenresRepo()
    
    override func bind(view: GeneralTableView) {
        super.bind(view: view)
        view.observer = self
        view.tableView.dataSource = self
        view.tableView.delegate = self
        view.tableView.register(MovieListCell.self, forCellReuseIdentifier: MovieListCell.reuseIdentifier)
        
        $navigationTitle.whenSet(view.navTitle) { navTitle, text in
            navTitle.text = text
        }.equalComparation()
        
        $moviesCellsVM.whenSet(view.tableView) { tableView, _ in
            tableView.reloadData()
        }.equalComparation()
        
        updateView()
    }
    
    override func bindToModelRepositories() {
        movieRepo?.whenSuccess { [weak self] results in
            guard let self = self else { return }
            self.loadPage = false
            let cellsVMs: [MovieListCellVM] = results.compactMap { result in
                build {
                    $0.posterImage = result.posterPath?.withTMDBImagePath
                    $0.rate = result.avgVote
                    $0.title = result.title
                    $0.originalTitle = result.originalTitle
                    $0.releaseDate = result.releaseDate
                    $0.genres = result.genreIds.compactMap { self.genresMap[$0] }
                }
            }
            self.moviesCellsVM = cellsVMs
        }.whenFailed { [weak self] error in
            guard let self = self else { return }
            if error.localizedDescription == "Max page excedded" {
                self.noMorePage = true
                return
            }
            self.view?.showToast(message: error.localizedDescription)
        }
        genresRepo.whenSuccess { [weak self] results in
            guard let self = self else { return }
            var genresMap: [Int: String] = [:]
            for result in results {
                genresMap[result.id] = result.name
            }
            self.genresMap = genresMap
        }
    }
    
    override func updateModel() {
        reloadAll()
        genresRepo.getModel()
    }
    
    func reloadAll() {
        guard let repo = movieRepo else { return }
        loadPage = true
        noMorePage = false
        repo.getModel(byParam: build { $0.reload = true })
    }
}

// MARK: Observer

extension AllMoviesVM: GeneralTableViewObserver {
    func generalTableView(_ view: GeneralTableView, didPullToRefresh refreshControl: UIRefreshControl) {
        reloadAll()
        refreshControl.endRefreshing()
    }
}

// MARK: UITableView DataSource & Delegate

extension AllMoviesVM: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesCellsVM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = moviesCellsVM[safe: indexPath.item],
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieListCell.reuseIdentifier, for: indexPath) as? MovieListCell else {
                return .init()
        }
        viewModel.bind(view: cell)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieListCell.preferedHeight(for: tableView, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.item == moviesCellsVM.count - 1, !loadPage, !noMorePage, let repo = movieRepo else { return }
        loadPage = true
        repo.getModel(byParam: build { $0.nextPage = true })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let view = view, let movie = movieRepo?.currentModel?[safe: indexPath.item] else {
            return
        }
        router.routeToMovieDetail(from: view, with: movie)
    }
    
}
