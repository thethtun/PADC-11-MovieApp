//
//  NetworkingAgent.swift
//  Starter
//
//  Created by Thet Htun on 5/23/21.
//

import Foundation
import Alamofire
import RxSwift



protocol MovieDBNetworkAgentProtocol {
    func getMovieTrailers(id : Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void)
    func getSimilarMovies(id : Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieCreditById(id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getMovieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
    
    func getTopRatedMovieList(page : Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
    func getPopularPeople(page : Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    
    func searchMovieByKeyword(query: String, page: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getSerieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)

    func getActorGallery(id : Int, completion: @escaping (MDBResult<ActorProfileInfo>) -> Void)
    func getActorDetails(id : Int, completion: @escaping (MDBResult<ActorDetailInfo>) -> Void)
    func getTVCredits(id : Int, completion: @escaping (MDBResult<ActorTVCredits>) -> Void)
}

class MovieDBNetworkAgent : BaseNetworkAgent, MovieDBNetworkAgentProtocol {
    
    static let shared = MovieDBNetworkAgent()
    
    var sessionManager: Session = AF
    
    private override init() { }
    
    func searchMovieByKeyword(query: String, page: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.searchMovie(page, query))
            .validate()
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }

    
    func getActorGallery(id : Int, completion : @escaping (MDBResult<ActorProfileInfo>) -> Void) {
        sessionManager.request(MDBEndpoint.actorImages(id))
            .responseDecodable(of: ActorProfileInfo.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getTVCredits(id : Int, completion : @escaping (MDBResult<ActorTVCredits>) -> Void) {
        sessionManager.request(MDBEndpoint.actorTVCredits(id))
            .responseDecodable(of: ActorTVCredits.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getActorDetails(id : Int, completion : @escaping (MDBResult<ActorDetailInfo>) -> Void) {
        sessionManager.request(MDBEndpoint.actorDetail(id))
            .responseDecodable(of: ActorDetailInfo.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieTrailers(id : Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.trailerVideo(id))
            .responseDecodable(of: MovieTrailerResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getSimilarMovies(id : Int, completion : @escaping (MDBResult<MovieListResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.similarMovie(id))
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieCreditById(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.movieActors(id))
            .responseDecodable(of: MovieCreditResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getSerieDetailById(id : Int, completion : @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.seriesDetails(id))
            .responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
               
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieDetailById(id : Int, completion : @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.movieDetails(id))
            .responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getPopularPeople(page : Int = 1, completion : @escaping (MDBResult<ActorListResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.popularActors(page))
            .responseDecodable(of: ActorListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getTopRatedMovieList(page : Int = 1, completion : @escaping (MDBResult<MovieListResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.topRatedMovies(page))
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    
    
    
    func getPopularSeriesList(completion : @escaping (MDBResult<MovieListResponse>) -> Void) {
        
        sessionManager.request(MDBEndpoint.popularTVSeries)
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getPopularMovieList(completion : @escaping (MDBResult<MovieListResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.popularMovie(1))
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        sessionManager.request(MDBEndpoint.upcomingMovie(1))
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let upcomingMovieList):
                    completion(.success(upcomingMovieList))
                case .failure(let error):
                    completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    
    
    func getGenreList(completion : @escaping (MDBResult<MovieGenreList>) -> Void) {
//        let url = "\(AppConstants.BaseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)"
        sessionManager.request(MDBEndpoint.movieGenres)
            .responseDecodable(of: MovieGenreList.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                //Handle Error
                completion(.failure(self.handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    

    
    /**
     Network Error - Different Scenarios
     
     * JSON Serialization Error
     * Wrong URL path
     * Incorrect method
     * Missing credentials
     * 4xx
     * 5xx
     
     */
    
    /// 3 - Customized Error Body
    
    
}
















