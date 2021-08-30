//
//  MovieModel.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation
import RxSwift
import RxCocoa

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
        
        let contentType : MovieSerieGroupType = .topRatedMovies
        
        networkAgent.getTopRatedMovieList(page: page) { (result) in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(type: contentType, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: contentType) {
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
        }
    }
    
    func fetchPopularMovieList() {
        let observableRemoteMovieList = RxNetworkAgent.shared.getPopularMovieList()
        observableRemoteMovieList
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .popularMovies, data: data)
            })
            .disposed(by: disposeBag)
    }
    
    let disposeBag = DisposeBag()
    func getPopularMovieList() -> Observable<[MovieResult]> {
        
        /**
         Show from database first
         
         Make network request
         - Success - Update Database -> Notify/Push -> Update UI
         - Fail - xxx
         */
        let observableRemoteMovieList = RxNetworkAgent.shared.getPopularMovieList()
        observableRemoteMovieList
            .subscribe(onNext: { data in
                self.movieRepository.saveList(type: .popularMovies, data: data)
            })
            .disposed(by: disposeBag)
        
        
        let observableLocalMovieList = ContentTypeRepositoryImpl.shared.getMoviesOrSeries(type: .popularMovies)
        return observableLocalMovieList

        
//        return RxNetworkAgent.shared.getPopularMovieList()
//            .do(onNext: { data in
//                self.movieRepository.saveList(type: .popularMovies, data: data)
//            })
//            .catchAndReturn(MovieListResponse.empty())
//            .flatMap { _ -> Observable<[MovieResult]> in
//                return Observable.create { (observer) -> Disposable in
//                    self.contentTypeRepository.getMoviesOrSeries(type: .popularMovies) {
//                        observer.onNext($0)
//                        observer.onCompleted()
//                    }
//                    return Disposables.create()
//                }
//            }
        
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
        
        /// [1] - Fetch from Network
        networkAgent.getGenreList { (result) in
            switch result {
            case .success(let data):
                
                /// [2] - Save to Database
                self.genreRepository.save(data: data)
                
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            /// [3] - Fetch inserted data from Database
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

