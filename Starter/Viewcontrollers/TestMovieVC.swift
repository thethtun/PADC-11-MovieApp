//
//  TestMovieViewController.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 14/01/2021.
//

import UIKit
import RxSwift

class TestMovieViewController: UIViewController {
    
    @IBOutlet weak var tableViewMovies: UITableView!
    private var refreshControl : UIRefreshControl = {
        let ui = UIRefreshControl()
        ui.tintColor = UIColor(named: "AccentColor")
        return ui
    }()
    
    //MARK: - Property
    private let movieModel : MovieModel = MovieModelImpl.shared
    private let actorModel : ActorModel = ActorModelImpl.shared
    
    private var upcomingMovieList = [MovieResult]()
    private var popularMovieList = [MovieResult]()
    private var popularSerieList = [MovieResult]()
    private var topRatedMovieList = [MovieResult]()
    private var genresMovieList = [MovieGenre]()
    private var popularPeople : [ActorInfoResponse]?
    
    
    let observableUpcomingMovies = RxMovieModelImpl.shared.getUpcomingMovieList()
    
    private let apiDispatchGroup = DispatchGroup()
    
    private let disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
         
        fetchData()
        
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.yellow
        
    }
    
    //MARK: - InitView
    private func registerTableViewCells(){
        tableViewMovies.dataSource = self
        tableViewMovies.refreshControl = refreshControl
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.fetchData()
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        tableViewMovies.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: GenreTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: BestActorTableViewCell.identifier)
    }
    
    private func setupNavigationItem() {
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "")
    }
    
    @IBAction func onClickSearch(_ sender : Any) {
        self.navigateToSearchContentViewController()
    }
    
    private func listenDispatchGroupEvents() {
        apiDispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
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
        
        fetchUpcomingMovieList()
        fetchPopularMovieList()
        fetchPopularTVSerieList()
        fetchMovieGenreList()
        fetchTopRatedMovieList()
        fetchPopularPeople()

//        listenDispatchGroupEvents()
    }
    
    func fetchPopularPeople() {
        apiDispatchGroup.enter()
        actorModel.getPopularPeople(page: 1) { [weak self] (result) in
            guard let self = self else { return }
            defer { self.apiDispatchGroup.leave() }
            switch result {
            case .success(let data):
                self.popularPeople = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_BEST_ACTOR.rawValue), with: .automatic)
            case .failure(let message):
                print(message)
            }
        }
    }
    
    func fetchTopRatedMovieList() {
        apiDispatchGroup.enter()
        movieModel.getTopRatedMovieList(page: 1) { [weak self](result) in
            guard let self = self else { return }
            defer { self.apiDispatchGroup.leave() }
            switch result {
            case .success(let data):
                self.topRatedMovieList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_SHOWCASE.rawValue), with: .automatic)
            case .failure(let message):
                print(message)
            }
        }
    }
    
    func fetchMovieGenreList() {
        apiDispatchGroup.enter()
        movieModel.getGenreList { [weak self](result) in
            guard let self = self else { return }
            defer { self.apiDispatchGroup.leave() }
            switch result {
            case .success(let data):
                self.genresMovieList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_GENRE.rawValue), with: .automatic)
            case .failure(let message):
                print(message)
            }
        }
    }
    
    func fetchUpcomingMovieList() {
//        observableUpcomingMovies
//            .map { [$0] }
//            .bind(
//                to: tableViewMovies.rx.items(
//                    cellIdentifier: MovieSliderTableViewCell.identifier,
//                    cellType: MovieSliderTableViewCell.self)
//            ) { row, element, cell in
//                cell.delegate = self
//                cell.data = element
//            }
//            .disposed(by: disposeBag)
        
        apiDispatchGroup.enter()
        movieModel.getUpcomingMovieList { [weak self](result) in
            guard let self = self else { return }
            defer { self.apiDispatchGroup.leave() }
            switch result {
            case .success(let data):
                self.upcomingMovieList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_SLIDER.rawValue), with: .automatic)
            case .failure(let message):
                print(message.debugDescription)
            }
        }
    }
    
    
    func fetchPopularMovieList() {
        let observablePopularMovies = MovieModelImpl.shared.getPopularMovieList()

        observablePopularMovies
            .subscribe (onNext: { (data) in
                self.popularMovieList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .automatic)
            }, onError: { (error) in
                print(error)
            }).disposed(by: disposeBag)
//
//        let observablePopularMovies = RxMovieModelImpl.shared.getPopularMovieList()
//        observablePopularMovies
//            .map { [$0] }
//            .bind(
//                to: tableViewMovies.rx.items(
//                    cellIdentifier: PopularFilmTableViewCell.identifier,
//                    cellType: PopularFilmTableViewCell.self)
//            ) { row, element, cell in
//                cell.labelTitle.text = "popular movies".uppercased()
//                cell.delegate = self
//                cell.data = element
//                cell.videoType = .movie
//            }
//            .disposed(by: disposeBag)

        
        
        
//        apiDispatchGroup.enter()
//        movieModel.getPopularMovieList { [weak self] (result) in
//            guard let self = self else { return }
////            defer { self.apiDispatchGroup.leave() }
//            switch result {
//            case .success(let data):
//                self.popularMovieList = data
//                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .automatic)
//            case .failure(let message):
//                print(message.debugDescription)
//            }
//        }
        
        
    }
    
    func fetchPopularTVSerieList() {
        apiDispatchGroup.enter()
        movieModel.getPopularSeriesList { [weak self](result) in
            guard let self = self else { return }
            defer { self.apiDispatchGroup.leave() }
            switch result {
            case .success(let data):
                self.popularSerieList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.SERIE_POPULAR.rawValue), with: .automatic)
            case .failure(let message):
                print(message.debugDescription)
            }
        }
    }
    
    
    
}

//MARK: - MovieItemDelegate
extension TestMovieViewController : MovieItemDelegate {
    
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

//MARK: - UITableViewDataSource
extension TestMovieViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case MovieType.MOVIE_SLIDER.rawValue:
            let cell = tableView.dequeueCell(identifier: MovieSliderTableViewCell.identifier, indexPath: indexPath) as MovieSliderTableViewCell
            cell.delegate = self
            cell.data = upcomingMovieList
            return cell
        case MovieType.MOVIE_POPULAR.rawValue:
            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.labelTitle.text = "popular movies".uppercased()
            cell.delegate = self
            cell.data = popularMovieList
            cell.videoType = .movie
            return cell
        case MovieType.SERIE_POPULAR.rawValue:
            let cell = tableView.dequeueCell(identifier: PopularFilmTableViewCell.identifier, indexPath: indexPath) as PopularFilmTableViewCell
            cell.labelTitle.text = "popular series".uppercased()
            cell.delegate = self
            cell.data = popularSerieList
            cell.videoType = .serie
            return cell
        case MovieType.MOVIE_SHOWTIME.rawValue:
            return tableView.dequeueCell(identifier: MovieShowTimeTableViewCell.identifier, indexPath: indexPath)
        case MovieType.MOVIE_GENRE.rawValue:
            let cell = tableView.dequeueCell(identifier: GenreTableViewCell.identifier, indexPath: indexPath) as GenreTableViewCell
            var movieList : [MovieResult] = []
            movieList.append(contentsOf: upcomingMovieList)
            movieList.append(contentsOf: popularSerieList)
            movieList.append(contentsOf: popularMovieList)
            
            let genreData : [GenreVO] = genresMovieList.map { movieGenre -> GenreVO in
                return movieGenre.toGenreVO()
            }
            genreData.first?.isSelected = true
            
            cell.data = (genreData, movieList)
            
            cell.onTapGenreMovie = { [weak self] movieId, videoType in
                guard let self = self else { return }
                self.onTapMovie(id: movieId, type: videoType)
            }
            
            return cell
        case MovieType.MOVIE_SHOWCASE.rawValue:
            let cell = tableView.dequeueCell(identifier: ShowCaseTableViewCell.identifier, indexPath: indexPath) as ShowCaseTableViewCell
            cell.data = topRatedMovieList
            cell.delegate = self
            return cell
        case MovieType.MOVIE_BEST_ACTOR.rawValue:
            let cell = tableView.dequeueCell(identifier: BestActorTableViewCell.identifier, indexPath: indexPath) as BestActorTableViewCell
            cell.data = popularPeople
            cell.onClickActorView = { actorId in
                self.navigateToActorDetailViewController(id: actorId)
            }
            cell.onClickViewMore = {
                self.navigateToViewMoreActorsViewController()
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
}
