//
//  NetworkingAgent.swift
//  Starter
//
//  Created by Thet Htun on 5/23/21.
//

import Foundation
import Alamofire

struct MovieDBNetworkAgent {
    
    static let shared = MovieDBNetworkAgent()
    
    private init() { }
    
    func searchMovieByKeyword(query: String, page: String, success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.searchMovie(page, query))
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    success(data)
                case .failure(let error):
                    failure(error.errorDescription!)
                }
            }
    }

    
    func getActorGallery(id : Int, success: @escaping (ActorProfileInfo) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.actorImages(id))
            .responseDecodable(of: ActorProfileInfo.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getTVCredits(id : Int, success: @escaping (ActorTVCredits) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.actorTVCredits(id))
            .responseDecodable(of: ActorTVCredits.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getActorDetails(id : Int, success: @escaping (ActorDetailInfo) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.actorDetail(id))
            .responseDecodable(of: ActorDetailInfo.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getMovieTrailers(id : Int, success: @escaping (MovieTrailerResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.trailerVideo(id))
            .responseDecodable(of: MovieTrailerResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getSimilarMovies(id : Int, success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.similarMovie(id))
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getMovieCreditById(id: Int, success: @escaping (MovieCreditResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.movieActors(id))
            .responseDecodable(of: MovieCreditResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getSerieDetailById(id : Int, success: @escaping (MovieDetailResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.seriesDetails(id))
            .responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
               
                failure(error.errorDescription!)
            }
        }
    }
    
    func getMovieDetailById(id : Int, success: @escaping (MovieDetailResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.movieDetails(id))
            .responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getPopularPeople(page : Int = 1, success: @escaping (ActorListResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.popularActors(page))
            .responseDecodable(of: ActorListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getTopRatedMovieList(page : Int = 1, success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.topRatedMovies(page))
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getGenreList(success: @escaping (MovieGenreList) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.movieGenres)
            .responseDecodable(of: MovieGenreList.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getPopularSeriesList(success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.popularTVSeries)
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getPopularMovieList(success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        AF.request(MDBEndpoint.popularMovie(1))
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.upcomingMovie(1))
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let upcomingMovieList):
                    completion(.success(upcomingMovieList))
                case .failure(let error):
                    completion(.failure(error.errorDescription!))
                }
            }
        
        
    }
}


enum MDBResult<T> {
    case success(T)
    case failure(String)
}
