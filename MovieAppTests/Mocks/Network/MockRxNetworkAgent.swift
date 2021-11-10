//
//  MockRxNetworkAgent.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import Foundation
@testable import Starter
import RxSwift

class MockRxNetworkAgent: RxNetworkAgentProtocol {
    
    func searchMovies(query: String, page: String) -> Observable<MovieListResponse> {
        let mockedDataFromJSON = try! Data(contentsOf: MovieMockData.SearchMovieResult.searchResultJSONUrl)

        let responseData = try! JSONDecoder().decode(MovieListResponse.self, from: mockedDataFromJSON)
        
        return Observable.just(responseData)
    }
    
    func getPopularMovieList() -> Observable<MovieListResponse> {
        Observable.never()
    }
    
    func getTopRatedMovieList(page: Int) -> Observable<MovieListResponse> {
        let mockedDataFromJSON = try! Data(contentsOf: MovieMockData.MovieList.topRatedMovieJSONUrl)

        let responseData = try! JSONDecoder().decode(MovieListResponse.self, from: mockedDataFromJSON)
        
        return Observable.just(responseData)
    }
    
    func getUpcomingMovieList() -> Observable<MovieListResponse> {
        Observable.never()
    }
    
    func getGenreList() -> Observable<MovieGenreList> {
        Observable.never()
    }
    
    func getPopularPeople(page: Int) -> Observable<ActorListResponse> {
        Observable.never()
    }
    
    func getPopularSeriesList() -> Observable<MovieListResponse> {
        Observable.never()
    }
    
    
}
