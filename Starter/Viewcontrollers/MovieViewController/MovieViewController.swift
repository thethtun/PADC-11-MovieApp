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
    private let disposeBag = DisposeBag()
    
    var viewModel: MovieViewModel!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieViewModel(movieModel: RxMovieModelImpl.shared, actorModel: ActorModelImpl.shared)
        
        initView()
        bindData()
        
        navigationController?.navigationBar.barStyle = .black
        
        viewModel.fetchAllData()
    }
    
    //MARK: - InitView
    private func initView() {
        setupRefreshControl()
        initTableView()
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor.yellow
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.handlePullToRefresh()
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
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
    
    private func bindData() {
        viewModel.homeItemList
            .bind(to: tableViewMovies.rx.items(dataSource: initDataSource()))
            .disposed(by: disposeBag)
    }
    
    @IBAction func onClickSearch(_ sender : Any) {
        self.navigateToSearchContentViewController()
    }
   
    @objc func handlePullToRefresh() {
        viewModel.handlePullToRefresh()
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

