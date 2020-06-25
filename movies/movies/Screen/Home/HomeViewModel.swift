//
//  HomeViewModel.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 24/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit

class HomeVM: ScreenViewModel<GeneralTableView> {
    @ViewModelBindable
    var navigationTitle: String?
    
    @ViewModelBindable
    var headlineCell: HeadlineMoviesCellVM = .init()
    
    @ViewModelBindable
    var popularCell: PopularMoviesCellVM = .init()
    
    @ViewModelBindable
    var genresCell: GenresCellVM = .init()
    
    @ViewModelBindable
    var newMovieCell: MoviesCellVM = .init()
    
    @ViewModelBindable
    var comingSoonCell: MoviesCellVM = .init()
    
    var router: GeneralRouterProtocol = GeneralRouter.shared
    
    private var sectionTitles: [String?] = [
        nil, "MOST POPULAR MOVIES", "GENRES",
        "NEW", "COMING SOON"
    ]
    
    private var sectionsVM: [SectionWithButtonVM?] = [
        nil, .init(), .init(), .init(), .init()
    ]
    
    private var heightCalculators: [(UITableView, IndexPath) -> CGFloat] = [
        HeadlineMoviesCell.preferedHeight, PopularMoviesCell.preferedHeight,
        GenresCell.preferedHeight, MoviesCell.preferedHeight,
        MoviesCell.preferedHeight
    ]
    
    override func bind(view: GeneralTableView) {
        super.bind(view: view)
        view.observer = self
        view.tableView.dataSource = self
        view.tableView.delegate = self
        
        $navigationTitle.whenSet(view.navTitle) { navTitle, text in
            navTitle.text = text
        }.equalComparation()
        
        setupNewMovie(with: view)
        setupComingSoon(with: view)
        bindRestOfTheCell(with: view)
        
        genresCell.onTapGenre = { [weak self] genre in
            guard let self = self, let view = self.view else { return }
            self.router.routeToMovieList(
                from: view,
                with: GenresMoviesRepo(for: genre),
                navigationTitle: genre.name
            )
        }
        
        updateView()
    }
    
    override func updateModel() {
        headlineCell.updateModel()
        popularCell.updateModel()
        genresCell.updateModel()
        newMovieCell.updateModel()
        comingSoonCell.updateModel()
    }
    
    private func setupNewMovie(with view: GeneralTableView) {
        newMovieCell.movieRepo = NewestMovieRepo()
        bindCell(view: view, with: $newMovieCell)
    }
    
    private func setupComingSoon(with view: GeneralTableView) {
        comingSoonCell.movieRepo = ComingSoonMovieRepo()
        bindCell(view: view, with: $comingSoonCell)
    }
    
    private func bindRestOfTheCell(with view: GeneralTableView) {
        bindCell(view: view, with: $headlineCell)
        bindCell(view: view, with: $popularCell)
        bindCell(view: view, with: $genresCell)
    }
    
    private func bindCell<View: UITableViewCell, VModel: ViewModel<View>>(
        view: GeneralTableView,
        with binder: ViewModelBinder<VModel>) where View: CellComponent {
        view.tableView.register(View.self, forCellReuseIdentifier: View.reuseIdentifier)
        bind(view: view, with: binder)
    }
    
    private func bind<VModel: Equatable>(view: GeneralTableView, with binder: ViewModelBinder<VModel>) {
        binder.whenSet(view.tableView) { tableView, _ in
            tableView.reloadData()
        }.equalComparation()
    }
}

extension HomeVM: GeneralTableViewObserver {
    func generalTableView(_ view: GeneralTableView, didPullToRefresh refreshControl: UIRefreshControl) {
        updateModel()
        refreshControl.endRefreshing()
    }
}

extension HomeVM: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return bind(viewModel: headlineCell, forTable: tableView, at: indexPath)
        case 1:
            return bind(viewModel: popularCell, forTable: tableView, at: indexPath)
        case 2:
            return bind(viewModel: genresCell, forTable: tableView, at: indexPath)
        case 3:
            return bind(viewModel: newMovieCell, forTable: tableView, at: indexPath)
        case 4:
            return bind(viewModel: comingSoonCell, forTable: tableView, at: indexPath)
        default:
            return .init()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { 5 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let optionalTitle = sectionTitles[safe: section],
            let title = optionalTitle,
            let optionalVM = sectionsVM[safe: section],
            let viewModel = optionalVM else {
                return nil
        }
        let view = SectionWithButton()
        viewModel.bind(view: view)
        viewModel.title = title
        viewModel.buttonTitle = section == 2 ? "" : "Show all"
        viewModel.onTap = { [weak self] _ in
            guard let self = self, let view = self.view else { return }
            switch section {
            case 1:
                self.router.routeToMovieList(
                    from: view, with: PopularMoviesRepo(),
                    navigationTitle: "most popular"
                )
            case 3:
                self.router.routeToMovieList(
                    from: view, with: LatestMoviesRepo(),
                    navigationTitle: "new movies"
                )
            case 4:
                self.router.routeToMovieList(
                    from: view, with: UpcomingMoviesRepo(),
                    navigationTitle: "coming soon"
                )
            default:
                break
            }
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 63
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCalculators[safe: indexPath.section]?(tableView, indexPath) ?? 0
    }
    
}
