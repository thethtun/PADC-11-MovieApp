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
    
    private var movieData: [MovieResult] = []
    private var genreData: [MovieGenre] = []
    
    init() {
        let movieDataJson = try! Data(contentsOf: MovieMockData.MovieList.topRatedMovieJSONUrl)
        let movieResponseData = try! JSONDecoder().decode(MovieListResponse.self, from: movieDataJson)
        movieData = movieResponseData.results!
        
        let genreDataJson = try! Data(contentsOf: MovieMockData.GenreList.genreListJSONUrl)
        let genreResponseData = try! JSONDecoder().decode(MovieGenreList.self, from: genreDataJson)
        genreData = genreResponseData.genres
        
    }
    
    func getTopRatedMovieList(page: Int) -> Observable<[MovieResult]> {
        if movieData.isEmpty { fatalError() }
        return Observable.just(movieData)
    }
    
    func getPopularMovieList() -> Observable<[MovieResult]> {
        if movieData.isEmpty { fatalError() }
        return Observable.just(movieData)
    }
    
    func getUpcomingMovieList() -> Observable<[MovieResult]> {
        if movieData.isEmpty { fatalError() }
        return Observable.just(movieData)
    }
    
    func getGenreList() -> Observable<[MovieGenre]> {
        if genreData.isEmpty { fatalError() }
        return Observable.just(genreData)
    }
    
    func getPopularSeriesList() -> Observable<[MovieResult]> {
        if movieData.isEmpty { fatalError() }
        return Observable.just(movieData)
    }
    
    func setUpDependencies(movieRepository: MovieRepository, contentTypeRepository: ContentTypeRepository, genreRepository: GenreRepository, rxNetworkAgent: RxNetworkAgentProtocol) {

    }
    
    
}
