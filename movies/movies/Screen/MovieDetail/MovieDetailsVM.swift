//
//  MovieDetailsVM.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import SkeletonView

class MovieDetailsVM: ScreenViewModel<TranslucentTableView> {
    
    @ViewModelBindable
    var headerCell: MovieDetailHeaderCellVM = .init()
    
    @ViewModelBindable
    var previewCell: MoviePreviewCellVM = .init()
    
    @ViewModelBindable
    var reviewsCell: [ReviewCellVM] = []
    
    @ViewModelBindable
    var backDrop: ImageCompatible?
    
    var hasVideo: Bool = false
    
    private var loadPage: Bool = false
    private var noMorePage: Bool = false
    
    // MARK: Injected Repositoriy
    var movieRepo: ModelRepository<MovieDetails, Void>? {
        didSet {
            bindToModelRepositories()
            reloadAll()
        }
    }
    
    var videoRepo: ModelRepository<MovieVideoPreview, Void>? {
        didSet {
            bindToModelRepositories()
            reloadAll()
        }
    }
    
    var reviewsRepo: ModelRepository<[MovieReviews.Review], InfiniteParam>? {
        didSet {
            bindToModelRepositories()
            reloadAll()
        }
    }
    
    override func bind(view: TranslucentTableView) {
        super.bind(view: view)
        view.observer = self
        setupTable(view.tableView)
        
        $backDrop.whenSet(view.translucentBackDrop) { backDrop, image in
            backDrop.imageCompat = image
        }.whenCompare { $0.equal(to: $1) }
        
        $previewCell.whenSet(view.tableView) { tableView, _ in
            tableView.reloadData()
        }.equalComparation()
        
        $headerCell.whenSet(view.tableView) { tableView, _ in
            tableView.reloadData()
        }.equalComparation()
        
        $reviewsCell.whenSet(view.tableView) { tableView, _ in
            tableView.reloadData()
        }.equalComparation()
        
        updateView()
    }
    
    override func bindToModelRepositories() {
        bindMovieRepository()
        bindVideoRepository()
        bindReviewsRepository()
    }
    
    private func bindReviewsRepository() {
        reviewsRepo?.whenSuccess { [weak self] results in
            guard let self = self else { return }
            self.loadPage = false
            let reviewsVM: [ReviewCellVM]  = results.compactMap { result in
                return build {
                    $0.author = result.author
                    $0.review = result.content
                }
            }
            self.reviewsCell = reviewsVM
        }.whenFailed { [weak self] error in
            guard let self = self else { return }
            if error.localizedDescription == "Max page excedded" {
                self.noMorePage = true
            }
        }
    }
    
    private func bindVideoRepository() {
        videoRepo?.whenSuccess { [weak self] results in
            guard let self = self, let result = results.results.first else { return }
            self.previewCell.youtubeCompat = result
            self.hasVideo = result.isCompatibleWithYoutube
            self.updateView()
        }.whenFailed { [weak self] _ in
            self?.hasVideo = false
        }
    }
    
    private func bindMovieRepository() {
        movieRepo?.whenSuccess { [weak self] result in
            guard let self = self else { return }
            self.headerCell.shimmer = false
            self.applyHeader(with: result)
            self.updateView()
        }.whenFailed { [weak self] _ in
            self?.headerCell.shimmer = false
            // do something
        }
    }
    
    private func applyHeader(with details: MovieDetails) {
        self.headerCell.title = details.title
        self.headerCell.originalTitle = details.originalTitle
        self.headerCell.rate = details.avgVote
        self.headerCell.duration = details.runtime
        self.headerCell.releaseDate = details.releaseDate
        self.headerCell.posterImage = details.posterPath?.withTMDBImagePath
        self.headerCell.genres = details.genres.compactMap { $0.name }
        self.headerCell.story = details.overview
    }
    
    override func updateModel() {
        reloadAll()
    }
    
    private func setupTable(_ tableView: UITableView) {
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 180
        tableView.register(MovieDetailHeaderCell.self, forCellReuseIdentifier: MovieDetailHeaderCell.reuseIdentifier)
        tableView.register(MoviePreviewCell.self, forCellReuseIdentifier: MoviePreviewCell.reuseIdentifier)
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.reuseIdentifier)
    }
    
    func reloadAll() {
        if let repo = movieRepo {
            headerCell.shimmer = true
            repo.getModel()
        }
        if let videoRepo = self.videoRepo {
            videoRepo.getModel()
        }
        if let reviewsRepo = self.reviewsRepo {
            reviewsRepo.getModel(byParam: build { $0.reload = true })
            loadPage = true
            noMorePage = false
        }
    }
}

extension MovieDetailsVM: TranslucentTableViewObserver {
    func translucentTableView(_ view: TranslucentTableView, didPullToRefresh refreshControl: UIRefreshControl) {
        reloadAll()
        refreshControl.endRefreshing()
    }
}

extension MovieDetailsVM: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return hasVideo ? 1 : reviewsCell.count
        case 2:
            return reviewsCell.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return bind(viewModel: headerCell, forTable: tableView, at: indexPath)
        case 1:
            if hasVideo {
                return bind(viewModel: previewCell, forTable: tableView, at: indexPath)
            }
            return bindReviewCell(for: tableView, at: indexPath)
        case 2:
            return bindReviewCell(for: tableView, at: indexPath)
        default:
            return .init()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { hasVideo ? 3 : 2 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 0 else {
            return nil
        }
        let viewModel = SectionWithButtonVM()
        let view = SectionWithButton()
        view.isHidden = reviewsCell.isEmpty
        viewModel.bind(view: view)
        viewModel.title = hasVideo ? (section == 1 ? "TRAILER" : "REVIEW") : "REVIEW"
        viewModel.buttonTitle = ""
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 63
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return hasVideo ? MoviePreviewCell.preferedHeight(for: tableView, at: indexPath) : UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == numberOfSections(in: tableView) - 1,
            indexPath.item == reviewsCell.count - 1,
            !loadPage, !noMorePage, let repo = reviewsRepo else { return }
        loadPage = true
        repo.getModel(byParam: build { $0.nextPage = true })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let denominator: CGFloat = 54
        let offset = scrollView.contentOffset.y
        let alpha = min(1, offset / denominator)
        self.view?.translucentBackDrop.frame.origin.y = min(0, -offset)
        self.view?.setNavbar(backgroundColorAlpha: alpha)
    }
    
    private func bindReviewCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = reviewsCell[safe: indexPath.item] else {
            return .init()
        }
        return bind(viewModel: cell, forTable: tableView, at: indexPath)
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
