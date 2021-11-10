//
//  RxMovieModel.swift
//  Starter
//
//  Created by Thet Htun on 8/29/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol RxMovieModel {
    func getTopRatedMovieList(page : Int) -> Observable<[MovieResult]>
    func getPopularMovieList() -> Observable<[MovieResult]>
    func getUpcomingMovieList() -> Observable<[MovieResult]>
    func getGenreList() -> Observable<[MovieGenre]>
    func getPopularSeriesList() -> Observable<[MovieResult]>
    
    func setUpDependencies(
        movieRepository : MovieRepository,
        contentTypeRepository : ContentTypeRepository,
        genreRepository : GenreRepository,
        rxNetworkAgent: RxNetworkAgentProtocol)
}

class RxMovieModelImpl: BaseModel, RxMovieModel {
    
    static let shared : RxMovieModel = RxMovieModelImpl()
    
    private override init() { }
    
    private var movieRepository : MovieRepository = MovieRepositoryImpl.shared
    private var contentTypeRepository : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    private var genreRepository : GenreRepository = GenreRepositoryImpl.shared
   
    private var rxNetworkAgent: RxNetworkAgentProtocol = RxNetworkAgent.shared
    
    let disposeBag = DisposeBag()
    
    func setUpDependencies(
        movieRepository : MovieRepository,
        contentTypeRepository : ContentTypeRepository,
        genreRepository : GenreRepository,
        rxNetworkAgent: RxNetworkAgentProtocol) {
        
        self.movieRepository = movieRepository
        self.contentTypeRepository = contentTypeRepository
        self.genreRepository = genreRepository
        self.rxNetworkAgent = rxNetworkAgent
    }
    
    func getTopRatedMovieList(page : Int) -> Observable<[MovieResult]>  {
        rxNetworkAgent.getTopRatedMovieList(page: page)
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .topRatedMovies, data: data)
            })
            .disposed(by: disposeBag)
            
        return ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .topRatedMovies)
    }
    
    func getPopularMovieList() -> Observable<[MovieResult]>  {
        rxNetworkAgent.getPopularMovieList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .popularMovies, data: data)
            })
            .disposed(by: disposeBag)
        
        return ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .popularMovies)
    }
    
    func getUpcomingMovieList() -> Observable<[MovieResult]>  {
        rxNetworkAgent.getUpcomingMovieList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .upcomingMovies, data: data)
            })
            .disposed(by: disposeBag)
            
        return ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .upcomingMovies)
    }
    
    func getGenreList() -> Observable<[MovieGenre]>  {
        rxNetworkAgent.getGenreList()
            .subscribe(onNext: { data in
                self.genreRepository.save(data: data)
            })
            .disposed(by: disposeBag)
            
        return GenreRepositoryImpl.shared.get()
    }
    
    func getPopularSeriesList() -> Observable<[MovieResult]>  {
        rxNetworkAgent.getPopularSeriesList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .upcomingSeries, data: data)
            })
            .disposed(by: disposeBag)
            
        return ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .upcomingSeries)
    }
    
}
