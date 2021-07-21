//
//  MovieDetailModel.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

protocol MovieDetailModel {
    func getMovieTrailers(id : Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void)
    func getSimilarMovies(id : Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieCreditById(id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getMovieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
}

class MovieDetailModelImpl: BaseModel, MovieDetailModel {
    
    static let shared : MovieDetailModelImpl = MovieDetailModelImpl()
    
    private override init() { }
    
    func getMovieTrailers(id : Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void) {
        networkAgent.getMovieTrailers(id: id, completion: completion)
    }
    
    func getSimilarMovies(id : Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getSimilarMovies(id: id, completion: completion)
    }
    
    func getMovieCreditById(id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void) {
        networkAgent.getMovieCreditById(id: id, completion: completion)
    }
    
    func getMovieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        networkAgent.getMovieDetailById(id: id, completion: completion)
    }
    
}
