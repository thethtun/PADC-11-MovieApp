//
//  MovieViewController.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 14/01/2021.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var tableViewMovies: UITableView!
    
    private let networkAgent : MovieDBNetworkAgentProtocol = MovieDBNetworkAgent.shared
    
    private var upcomingMovieList : MovieListResponse?
    private var popularMovieList : MovieListResponse?
    private var popularSerieList : MovieListResponse?
    private var topRatedMovieList : MovieListResponse?
    private var genresMovieList : MovieGenreList?
    private var popularPeople : ActorListResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "")
        
        fetchUpcomingMovieList()
        fetchPopularMovieList()
        fetchPopularTVSerieList()
        fetchMovieGenreList()
        fetchTopRatedMovieList()
        fetchPopularPeople()
    }
    
    private func registerTableViewCells(){
        tableViewMovies.dataSource = self
        
        tableViewMovies.registerForCell(identifier: MovieSliderTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: PopularFilmTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: MovieShowTimeTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: GenreTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: ShowCaseTableViewCell.identifier)
        tableViewMovies.registerForCell(identifier: BestActorTableViewCell.identifier)
    }
    
    @IBAction func onClickSearch(_ sender : Any) {
        self.navigateToSearchContentViewController()
    }
    
    
    func fetchPopularPeople() {
        networkAgent.getPopularPeople(page: 1) { (result) in
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
        networkAgent.getTopRatedMovieList(page: 1) { (result) in
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
        networkAgent.getGenreList { (result) in
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
        networkAgent.getUpcomingMovieList { (result) in
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
        networkAgent.getPopularMovieList { (result) in
            switch result {
            case .success(let data):
                self.popularMovieList = data
                self.tableViewMovies.reloadSections(IndexSet(integer: MovieType.MOVIE_POPULAR.rawValue), with: .automatic)
            case .failure(let message):
                print(message.debugDescription)
            }
        }
        
    }
    
    func fetchPopularTVSerieList() {
        networkAgent.getPopularSeriesList { (result) in
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

extension MovieViewController : MovieItemDelegate {
    
    func onTapViewMore(data: MovieListResponse) {
        self.navigateToViewMoreMovieShowCaseViewController(data: data)
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

extension MovieViewController : UITableViewDataSource{
    
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
            movieList.append(contentsOf: upcomingMovieList?.results ?? [MovieResult]())
            movieList.append(contentsOf: popularSerieList?.results ?? [MovieResult]())
            movieList.append(contentsOf: popularMovieList?.results ?? [MovieResult]())
            cell.allMoviesAndSeries = movieList
            
            let resultData : [GenreVO]? = genresMovieList?.genres.map { movieGenre -> GenreVO in
                return movieGenre.convertToGenreVO()
            }
            resultData?.first?.isSelected = true
            cell.genreList = resultData
            
            
            cell.onTapGenreMovie = { [weak self] movieId in
                guard let self = self else { return }
                self.onTapMovie(id: movieId, type: .movie)
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
            cell.onClickViewMore = {data in
                self.navigateToViewMoreActorsViewController(data: data)
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    
}
