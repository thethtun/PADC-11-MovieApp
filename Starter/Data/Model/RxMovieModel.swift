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
}

class RxMovieModelImpl: BaseModel, RxMovieModel {
    
    static let shared : RxMovieModel = RxMovieModelImpl()
    
    private override init() { }
    
    private let movieRepository : MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    private let genreRepository : GenreRepository = GenreRepositoryImpl.shared
    
    let disposeBag = DisposeBag()
    
    func getTopRatedMovieList(page : Int) -> Observable<[MovieResult]>  {
        RxNetworkAgent.shared.getTopRatedMovieList(page: page)
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .topRatedMovies, data: data)
            })
            .disposed(by: disposeBag)
            
        return ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .topRatedMovies)
    }
    
    func getPopularMovieList() -> Observable<[MovieResult]>  {
        RxNetworkAgent.shared.getPopularMovieList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .popularMovies, data: data)
            })
            .disposed(by: disposeBag)
        
        return ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .popularMovies)
    }
    
    func getUpcomingMovieList() -> Observable<[MovieResult]>  {
        RxNetworkAgent.shared.getUpcomingMovieList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .upcomingMovies, data: data)
            })
            .disposed(by: disposeBag)
            
        return ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .upcomingMovies)
    }
    
    func getGenreList() -> Observable<[MovieGenre]>  {
        RxNetworkAgent.shared.getGenreList()
            .subscribe(onNext: { data in
                self.genreRepository.save(data: data)
            })
            .disposed(by: disposeBag)
            
        return .empty()
    }
    
    func getPopularSeriesList() -> Observable<[MovieResult]>  {
        RxNetworkAgent.shared.getPopularSeriesList()
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .upcomingMovies, data: data)
            })
            .disposed(by: disposeBag)
            
        return .empty()
    }
    
}
