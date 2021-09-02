//
//  MovieDataSource.swift
//  Starter
//
//  Created by Thet Htun on 9/2/21.
//

import Foundation
import RxDataSources
import UIKit

extension MovieViewController {
    func initDataSource() -> RxTableViewSectionedReloadDataSource<HomeMovieSectionModel> {
        
        return RxTableViewSectionedReloadDataSource<HomeMovieSectionModel>.init { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .popularMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.labelTitle.text = "popular movies".uppercased()
                cell.delegate = self
                cell.data = items
                cell.videoType = .movie
                return cell
            case .upcomingMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
                cell.delegate = self
                cell.data = items
                return cell
            case .bestActorSection(let items):
                let cell = tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
                cell.data = items
                cell.onClickActorView = { actorId in
                    self.navigateToActorDetailViewController(id: actorId)
                }
                cell.onClickViewMore = {
                    self.navigateToViewMoreActorsViewController()
                }
                return cell
            case .showcaseMoviesSection(let items):
                let cell = tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
                cell.data = items
                cell.delegate = self
                return cell
            case .popularSeriesSection(let items):
                let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
                cell.labelTitle.text = "popular series".uppercased()
                cell.delegate = self
                cell.data = items
                cell.videoType = .serie
                return cell
            case .movieShowTimeSection:
                let cell = tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
                return cell
            case .movieGenreSection(let genres, let movies):
                let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
                cell.allMoviesAndSeries = movies
                
                let resultData : [GenreVO] = genres.map { movieGenre -> GenreVO in
                    return movieGenre.toGenreVO()
                }
                resultData.first?.isSelected = true
                cell.genreList = resultData
                
                
                cell.onTapGenreMovie = { [weak self] movieId, videoType in
                    guard let self = self else { return }
                    self.onTapMovie(id: movieId, type: videoType)
                }
                
                return cell
            }
        }
    }
}
