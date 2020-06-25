//
//  MoviePreviewCell.swift
//  movies
//
//  Created by Nayanda Haberty (ID) on 25/06/20.
//  Copyright © 2020 Nayanda Haberty (ID). All rights reserved.
//

import Foundation
import UIKit
import youtube_ios_player_helper_swift

class MoviePreviewCell: UITableViewCell, CalculatedTableCellComponent {
    
    typealias Observer = Void
    
    static func preferedHeight(for table: UITableView, at indexPath: IndexPath) -> CGFloat {
        let marginedWidth = table.frame.width - 54
        let marginedHeight = marginedWidth * 0.5625
        return marginedHeight + 54
    }
    
    static var reuseIdentifier: String = "movie_preview_cell"
    
    lazy var videoOutputView: YTPlayerView = .init()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .white
        backgroundColor = .white
        videoOutputView.backgroundColor = .black
        contentView.addSubview(videoOutputView)
        videoOutputView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(27)
            make.height.equalTo(videoOutputView.snp.width).multipliedBy(0.5625)
        }
    }
}

// MARK: View Model

class MoviePreviewCellVM: ViewModel<MoviePreviewCell> {
    @ViewModelBindable
    var youtubeCompat: YoutubeCompatible?
    
    override func bind(view: MoviePreviewCell) {
        $youtubeCompat.whenSet(view.videoOutputView) { output, youtubeCompat in
            guard let videoId = youtubeCompat?.videoId else {
                return
            }
            _ = output.load(videoId: videoId)
            output.isUserInteractionEnabled = true
            
        }
        updateView()
    }
}

