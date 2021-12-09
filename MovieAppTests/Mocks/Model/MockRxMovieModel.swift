//
//  MockRxMovieModel.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import Foundation
@testable import Starter
import RxSwift

class MockRxMovieModel: RxMovieModel {
    
    var movieData: [MovieResult] = []
    var genreData: [MovieGenre] = []
    
    var upcomingMoviesAreEmpty: Bool = false
    
    init() {
        let movieDataJson: Data = try! Data(contentsOf: MovieMockData.MovieList.topRatedMovieJSONUrl)
        let movieResponseData: MovieListResponse = try! JSONDecoder().decode(MovieListResponse.self, from: movieDataJson)
        movieData = movieResponseData.results!
        
        let genreDataJson = try! Data(contentsOf: MovieMockData.GenreList.genreListJSONUrl)
        let genreResponseData = try! JSONDecoder().decode(MovieGenreList.self, from: genreDataJson)
        genreData = genreResponseData.genres
    }
    
    func getTopRatedMovieList(page: Int) -> Observable<[MovieResult]> {
        return Observable.just(movieData)
    }
    
    func getPopularMovieList() -> Observable<[MovieResult]> {
        return Observable.just(movieData)
    }
    
    func getUpcomingMovieList() -> Observable<[MovieResult]> {
        return Observable.create { observers -> Disposable in
            if self.upcomingMoviesAreEmpty {
                observers.onNext([MovieResult]())
            } else {
                observers.onNext(self.movieData)
            }
            
            observers.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func getGenreList() -> Observable<[MovieGenre]> {
        return Observable.just(genreData)
    }
    
    func getPopularSeriesList() -> Observable<[MovieResult]> {
        return Observable.just(movieData)
    }
    
    func setUpDependencies(movieRepository: MovieRepository, contentTypeRepository: ContentTypeRepository, genreRepository: GenreRepository, rxNetworkAgent: RxNetworkAgentProtocol) {

    }
    
    
}
