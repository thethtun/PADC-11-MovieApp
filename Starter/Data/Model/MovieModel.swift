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
    func getGenreList(completion: @escaping (MDBResult<[MovieGenre]>) -> Void)
    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
}

class MovieModelImpl: BaseModel, MovieModel {
    
    static let shared : MovieModelImpl = MovieModelImpl()
    
    private override init() { }
    
    private let movieRepository : MovieRepository = MovieRepositoryImpl.shared
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    private let genreRepository : GenreRepository = GenreRepositoryImpl.shared
    
    func getTopRatedMovieList(page : Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getTopRatedMovieList(page: page) { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: .topRatedMovies, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: .topRatedMovies) {
                completion(.success($0))
            }
        }
    }
    
    func getPopularMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getPopularMovieList { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: .popularMovies, data: data)
            case .failure(let error):
                print(error)
            }
              
            self.contentTypeRepository.getMoviesOrSeries(type: .popularMovies) {
                completion(.success($0))
            }
        }
    }
    
    func getUpcomingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getUpcomingMovieList { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: .upcomingMovies, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: .upcomingMovies) {
                completion(.success($0))
            }
        }
    }
    
    func getGenreList(completion: @escaping (MDBResult<[MovieGenre]>) -> Void) {
        networkAgent.getGenreList { (result) in
            switch result {
            case .success(let data):
                self.genreRepository.save(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.genreRepository.get { completion(.success($0)) }
        }
    }
    
    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getPopularSeriesList { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: .upcomingSeries, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: .upcomingSeries) {
                completion(.success($0))
            }
        }
    }
    
    
    
    
}

