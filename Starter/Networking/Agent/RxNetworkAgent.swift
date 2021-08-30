//
//  RxNetworkAgent.swift
//  Starter
//
//  Created by Thet Htun on 8/19/21.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

enum MDBError : Error {
    case withMessage(String)
}

protocol RxNetworkAgentProtocol  {
    func searchMovies(query: String, page: String) -> Observable<MovieListResponse>
    
    func getPopularMovieList() -> Observable<MovieListResponse>
    func getTopRatedMovieList(page : Int) -> Observable<MovieListResponse>
    func getUpcomingMovieList() -> Observable<MovieListResponse>
    func getGenreList() -> Observable<MovieGenreList>
    func getPopularPeople(page : Int) -> Observable<ActorListResponse>
    func getPopularSeriesList() -> Observable<MovieListResponse>
}

class RxNetworkAgent : BaseNetworkAgent, RxNetworkAgentProtocol {
    
    static let shared  = RxNetworkAgent()
    
    private override init() {
        
    }
    
    func searchMovies(query: String, page: String) -> Observable<MovieListResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.searchMovie(page, query))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getPopularMovieList() -> Observable<MovieListResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.popularMovie(1))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getTopRatedMovieList(page : Int) -> Observable<MovieListResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.topRatedMovies(1))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getUpcomingMovieList() -> Observable<MovieListResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.upcomingMovie(1))
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getGenreList() -> Observable<MovieGenreList> {
        RxAlamofire.requestDecodable(MDBEndpoint.movieGenres)
            .flatMap { item -> Observable<MovieGenreList> in
                return Observable.just(item.1)
            }
    }
    
    func getPopularPeople(page : Int) -> Observable<ActorListResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.popularActors(page))
            .flatMap { item -> Observable<ActorListResponse> in
                return Observable.just(item.1)
            }
    }
    
    func getPopularSeriesList() -> Observable<MovieListResponse> {
        RxAlamofire.requestDecodable(MDBEndpoint.popularTVSeries)
            .flatMap { item -> Observable<MovieListResponse> in
                return Observable.just(item.1)
            }
    }
    
}
