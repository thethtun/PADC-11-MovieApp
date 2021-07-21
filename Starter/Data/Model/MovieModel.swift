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
    
    private let movieRepository : MovieRepository = MovieRepositoryImpl.shared
    
    func getTopRatedMovieList(page : Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getTopRatedMovieList(page: page, completion: completion)
    }
    
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.getPopularMovieList { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.save(type: .popular, data: data)
            case .failure(let error):
                print(error)
            }
            
            self.movieRepository.get(type: .popular) {
                let vos = $0.map { MovieEntity.toMovieResult(entity: $0) }
                completion(.success(MovieListResponse(dates: nil, page: nil, results: vos, totalPages: nil, totalResults: nil)))
            }
        }
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

