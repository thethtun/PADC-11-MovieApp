//
//  MovieDetailModel.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

protocol MovieDetailModel {
    func getMovieTrailers(id : Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void)
    func getSimilarMovies(id : Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getMovieCreditById(id: Int, completion: @escaping (MDBResult<[MovieCast]>) -> Void)
    func getMovieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
    func getSerieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
}

class MovieDetailModelImpl: BaseModel, MovieDetailModel {
    
    static let shared : MovieDetailModelImpl = MovieDetailModelImpl()
    
    private override init() { }
    
    private let movieRepository : MovieRepository = MovieRepositoryImpl.shared
    
    func getMovieTrailers(id : Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void) {
        networkAgent.getMovieTrailers(id: id, completion: completion)
    }
    
    func getSimilarMovies(id : Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getSimilarMovies(id: id) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveSimilarContent(id: id, data: data.results ?? [MovieResult]())
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRepository.getSimilarContent(id: id) {
                completion(.success($0))
            }
        }
    }
    
    func getMovieCreditById(id: Int, completion: @escaping (MDBResult<[MovieCast]>) -> Void) {
        networkAgent.getMovieCreditById(id: id) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveCasts(id: id, data: data.cast ?? [MovieCast]())
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRepository.getCasts(id: id) {
                completion(.success($0))
            }
        }
    }
    
    func getSerieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        networkAgent.getSerieDetailById(id: id) {(result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveDetail(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.movieRepository.getDetail(id: id) { (item) in
                if let item = item {
                    completion(.success(item))
                } else {
                    completion(.failure("Failed to get detail with id \(id)"))
                }
            }
            
        }
    }
    
    func getMovieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        networkAgent.getMovieDetailById(id: id) { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveDetail(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }

            self.movieRepository.getDetail(id: id) { (item) in
                if let item = item {
                    completion(.success(item))
                } else {
                    completion(.failure("Failed to get detail with id \(id)"))
                }
            }
            
        }
    }
    
}
