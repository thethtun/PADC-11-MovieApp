//
//  MovieModel.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

protocol MovieModel {
    func getTopRatedMovieList(page : Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
    func getPopularPeople(page : Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getSerieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
}

class MovieModelImpl: BaseModel, MovieModel {
    
    static let shared : MovieModelImpl = MovieModelImpl()
    
    private override init() { }
    
    func getTopRatedMovieList(page : Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getTopRatedMovieList(page: page, completion: completion)
    }
    
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getPopularMovieList(completion: completion)
    }
    
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getUpcomingMovieList(completion: completion)
    }
    
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void) {
        networkAgent.getGenreList(completion: completion)
    }
    
    func getPopularPeople(page : Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void) {
        networkAgent.getPopularPeople(page: page, completion: completion)
    }
    
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getPopularSeriesList(completion: completion)
    }
    
    func getSerieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        networkAgent.getSerieDetailById(id: id, completion: completion)
    }
}

