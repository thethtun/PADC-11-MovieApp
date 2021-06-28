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
    
    func getActorGallery(id : Int, success: @escaping (ActorProfileInfo) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/person/\(id)/images?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: ActorProfileInfo.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getTVCredits(id : Int, success: @escaping (ActorTVCredits) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/person/\(id)/tv_credits?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: ActorTVCredits.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getActorDetails(id : Int, success: @escaping (ActorDetailInfo) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/person/\(id)?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: ActorDetailInfo.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getMovieTrailers(id : Int, success: @escaping (MovieTrailerResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/movie/\(id)/videos?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieTrailerResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getSimilarMovies(id : Int, success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/movie/\(id)/similar?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getMovieCreditById(id: Int, success: @escaping (MovieCreditResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/movie/\(id)/credits?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieCreditResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getSerieDetailById(id : Int, success: @escaping (MovieDetailResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/tv/\(id)?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
               
                failure(error.errorDescription!)
            }
        }
    }
    
    func getMovieDetailById(id : Int, success: @escaping (MovieDetailResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/movie/\(id)?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getPopularPeople(success: @escaping (ActorListResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/person/popular?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: ActorListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getTopRatedMovieList(success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/movie/top_rated?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getGenreList(success: @escaping (MovieGenreList) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieGenreList.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getPopularSeriesList(success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/tv/popular?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getPopularMovieList(success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/movie/popular?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
    func getUpcomingMovieList(success: @escaping (MovieListResponse) -> Void, failure: @escaping (String) -> Void) {
        let url = "\(AppConstants.BaseURL)/movie/upcoming?api_key=\(AppConstants.apiKey)"
        AF.request(url).responseDecodable(of: MovieListResponse.self) { response in
            //AFDataResponse<UpcomingMovieList>
            switch response.result {
            case .success(let upcomingMovieList):
                success(upcomingMovieList)
            case .failure(let error):
                failure(error.errorDescription!)
            }
        }
    }
    
}
