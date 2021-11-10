//
//  MovieViewModel.swift
//  Starter
//
//  Created by Thet Htun on 10/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel {
    
    //Observables
    let homeItemList                        = BehaviorRelay<[HomeMovieSectionModel]>(value: [])
    private var observablePopularMovies     = BehaviorRelay<[MovieResult]>(value:[])
    private var observableTopRatedMovies    = BehaviorRelay<[MovieResult]>(value:[])
    private var observableUpcomingMovies    = BehaviorRelay<[MovieResult]>(value:[])
    private var observableActorList         = BehaviorRelay<[ActorInfoResponse]>(value:[])
    private var observablePopularSeries     = BehaviorRelay<[MovieResult]>(value:[])
    private var observableGenreList         = BehaviorRelay<[MovieGenre]>(value:[])
    
    //Models
    private var movieModel          = RxMovieModelImpl.shared
    private var actorModel          = ActorModelImpl.shared
    
    private let disposeBag = DisposeBag()

    init(movieModel: RxMovieModel,
         actorModel: ActorModel) {
        
        self.movieModel = movieModel
        self.actorModel = actorModel
        
        initObservers()
        
        print("View Model initialized")
        
        observablePopularMovies
            .subscribe ( onNext: { results in
                print("MovieResult Changes: \(results.count)")
            }, onError: { error in
                print(error)
            }).disposed(by: disposeBag)

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
        .subscribe { (
            genreList,
            topRatedMovies,
            popularMovies,
            popularSeries,
            upcomingMovies,
            actorList) in
            
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
            print("duh:: \(items.count)")
            self.homeItemList.accept(items)
        }.disposed(by: disposeBag)

    }
    
    func handlePullToRefresh() {
        fetchAllData()
    }
    
    func fetchAllData() {
        getPopularMovieList()
        getPopularSeriesList()
        getTopRatedMovieList(page: 1)
        getUpcomingMovieList()
        getPopularPeople(page: 1)
        getGenreList()
    }
    
    func getPopularMovieList() {
        movieModel.getPopularMovieList()
            .subscribe(onNext: {
                self.observablePopularMovies.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func getPopularSeriesList() {
        movieModel.getPopularSeriesList()
            .subscribe(onNext: { items in
                self.observablePopularSeries.accept(items)
            })
            .disposed(by: disposeBag)
    }
    
    func getTopRatedMovieList(page: Int) {
        movieModel.getTopRatedMovieList(page: 1)
            .subscribe(onNext: {
                self.observableTopRatedMovies.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func getUpcomingMovieList() {
        movieModel.getUpcomingMovieList()
            .subscribe(onNext: {
                self.observableUpcomingMovies.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func getPopularPeople(page: Int) {
        actorModel.getPopularPeople(page: 1)
            .subscribe(onNext: { self.observableActorList.accept($0) })
            .disposed(by: disposeBag)
    }
    
    func getGenreList() {
        movieModel.getGenreList()
            .subscribe(onNext: { self.observableGenreList.accept($0) })
            .disposed(by: disposeBag)
    }
    
}
