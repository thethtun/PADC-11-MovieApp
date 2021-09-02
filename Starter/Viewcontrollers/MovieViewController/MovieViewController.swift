//
//  MovieViewController.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 14/01/2021.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

class MovieViewController: UIViewController {
    
    @IBOutlet weak var tableViewMovies: UITableView!
    
    private var refreshControl : UIRefreshControl = {
        let ui = UIRefreshControl()
        ui.tintColor = UIColor(named: "AccentColor")
        return ui
    }()
    
    //MARK: - Property
    private let movieModel          = RxMovieModelImpl.shared
    private let actorModel          = ActorModelImpl.shared
    
    private var observablePopularMovies     = BehaviorRelay<[MovieResult]>(value:[])
    private var observableTopRatedMovies    = BehaviorRelay<[MovieResult]>(value:[])
    private var observableUpcomingMovies    = BehaviorRelay<[MovieResult]>(value:[])
    private var observableActorList         = BehaviorRelay<[ActorInfoResponse]>(value:[])
    private var observablePopularSeries     = BehaviorRelay<[MovieResult]>(value:[])
    private var observableGenreList         = BehaviorRelay<[MovieGenre]>(value:[])
    
    private let disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
            
        initObservable()
            
        initObservers()
            
        fetchData()
    }
  
    private func initObservable() {
        movieModel.getPopularMovieList()
            .subscribe(onNext: { self.observablePopularMovies.accept($0) })
            .disposed(by: disposeBag)
        
        movieModel.getPopularSeriesList()
            .subscribe(onNext: { items in
                self.observablePopularSeries.accept(items)
            })
            .disposed(by: disposeBag)

        movieModel.getTopRatedMovieList(page: 1)
            .subscribe(onNext: { self.observableTopRatedMovies.accept($0) })
            .disposed(by: disposeBag)

        movieModel.getUpcomingMovieList()
            .subscribe(onNext: { self.observableUpcomingMovies.accept($0) })
            .disposed(by: disposeBag)

        actorModel.getPopularPeople(page: 1)
            .subscribe(onNext: { self.observableActorList.accept($0) })
            .disposed(by: disposeBag)

        movieModel.getGenreList()
            .subscribe(onNext: { self.observableGenreList.accept($0) })
            .disposed(by: disposeBag)
    }
    
    private func initView() {
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.yellow
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.fetchData()
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        initTableView()
    }
    
    //MARK: - InitView
    private func initTableView()  {
//        tableViewMovies.dataSource = self
        tableViewMovies.refreshControl = refreshControl
        
        tableViewMovies.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: GenreTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: BestActorTableViewCell.identifier)
        
    }
    
    private func initObservers() {
        Observable.combineLatest(
            observableGenreList,
            observableTopRatedMovies,
            observablePopularMovies,
            observablePopularSeries,
            observableUpcomingMovies,
            observableActorList
        )
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .flatMap { (
            genreList,
            topRatedMovies,
            popularMovies,
            popularSeries,
            upcomingMovies,
            actorList) -> Observable<[HomeMovieSectionModel]> in
            var items = [HomeMovieSectionModel]()
            if !upcomingMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.upcomingMoviesSection(items: upcomingMovies)]))
            }
            
            if !popularMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.popularMoviesSection(items: popularMovies)]))
            }
            
            if !popularSeries.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.popularSeriesSection(items: popularSeries)]))
            }
            
            items.append(HomeMovieSectionModel.others(items: [.movieShowTimeSection]))
            
            if !genreList.isEmpty {
                items.append(HomeMovieSectionModel.genreResult(items: [.movieGenreSection(genres: genreList, movies: upcomingMovies + popularMovies + popularSeries)]))
            }
            
            if !topRatedMovies.isEmpty {
                items.append(HomeMovieSectionModel.movieResult(items: [.showcaseMoviesSection(items: topRatedMovies)]))
            }
            
            if !actorList.isEmpty {
                items.append(HomeMovieSectionModel.actorResult(items: [.bestActorSection(items: actorList)]))
            }
            return .just(items)
        }.bind(to: tableViewMovies.rx.items(dataSource: initDataSource()))
        .disposed(by: disposeBag)
        
        
    }
    
    @IBAction func onClickSearch(_ sender : Any) {
        self.navigateToSearchContentViewController()
    }
    
    // Shorten Pull Distance on UIRefreshControl
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -80 { //change 80 to whatever you want
            if  !self.refreshControl.isRefreshing {
                handlePullToRefresh()
            }
        }
    }
    
    @objc func handlePullToRefresh() {
        fetchData()
    }
    
    //MARK: - API Methods
    func fetchData() {
        initObservable()
    }
    
}

//MARK: - MovieItemDelegate
extension MovieViewController : MovieItemDelegate {
    
    func onTapViewMore() {
        self.navigateToViewMoreMovieShowCaseViewController()
    }
    
    func onTapMovie(id : Int, type : VideoType) {
        switch type {
        case .movie:
            navigateToMovieDetailViewController(movieId : id)
        case .serie:
            navigateToSerieDetailViewController(id: id)
        }
        
    }
}

