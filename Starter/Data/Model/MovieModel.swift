//
//  MovieModel.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

protocol MovieModel {
    func getTopRatedMovieList(page : Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getUpcomingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
    func getPopularPeople(page : Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    
    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getSerieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
}

class MovieModelImpl: BaseModel, MovieModel {
    
    static let shared : MovieModelImpl = MovieModelImpl()
    
    private override init() { }
    
    private let movieRepository : MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    func getTopRatedMovieList(page : Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getTopRatedMovieList(page: page) { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.save(type: .topRatedMovies, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: .topRatedMovies) {
                let vos = $0.map { MovieEntity.toMovieResult(entity: $0) }
                completion(.success(vos))
            }
        }
    }
    
    func getPopularMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getPopularMovieList { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.save(type: .popularMovies, data: data)
            case .failure(let error):
                print(error)
            }
                        
            self.contentTypeRepository.getMoviesOrSeries(type: .popularMovies) {
                let vos = $0.map { MovieEntity.toMovieResult(entity: $0) }
                completion(.success(vos))
            }
        }
    }
    
    func getUpcomingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getUpcomingMovieList { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.save(type: .upcomingMovies, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: .upcomingMovies) {
                let vos = $0.map { MovieEntity.toMovieResult(entity: $0) }
                completion(.success(vos))
            }
        }
    }
    
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void) {
        networkAgent.getGenreList(completion: completion)
    }
    
    func getPopularPeople(page : Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void) {
        networkAgent.getPopularPeople(page: page, completion: completion)
    }
    
    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getPopularSeriesList { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.save(type: .upcomingSeries, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: .upcomingSeries) {
                let vos = $0.map { MovieEntity.toMovieResult(entity: $0) }
                completion(.success(vos))
            }
        }
    }
    
    func getSerieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        networkAgent.getSerieDetailById(id: id, completion: completion)
    }
    
    
    
}

