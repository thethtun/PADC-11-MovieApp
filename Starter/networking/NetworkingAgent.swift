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
                    failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
               
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
            }
        }
    }
    
    
    
    func getGenreList(success: @escaping (MovieGenreList) -> Void, failure: @escaping (String) -> Void) {
//        AF.request("https://getstatuscode.com/500")
        AF.request(MDBEndpoint.movieGenres)
//        AF.request("\(AppConstants.BaseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)")
            .responseDecodable(of: MovieGenreList.self) { response in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                failure(handleError(response, error, MDBCommonResponseError.self))
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
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }
    
    fileprivate func handleError<T, E: MDBErrorModel>(_ response: DataResponse<T, AFError>, _ error: (AFError), _ errorBodyType : E.Type) -> String {
        var respBody : String = ""
        
        var serverErrorMessage : String?
        
        var errorBody : E?
        if let respData = response.data {
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            
            errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        let respCode : Int = response.response?.statusCode ?? 0
        
        let sourcePath = response.request?.url?.absoluteString ?? "no url"
        
        print(
            """
             ======================
             URL
             -> \(sourcePath)
             
             Status
             -> \(respCode)
             
             Body
             -> \(respBody)

             Underlying Error
             -> \(error.underlyingError!)
             
             Error Description
             -> \(error.errorDescription!)
             ======================
            """
        )
        
        return serverErrorMessage ?? error.errorDescription ?? "undefined"
        
    }
    
}

protocol MDBErrorModel : Decodable {
    var message : String { get }
}

class MDBCommonResponseError : MDBErrorModel {
    var message: String {
        return statusMessage
    }
    
    let statusMessage : String
    let statusCode : Int
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}


enum MDBResult<T> {
    case success(T)
    case failure(String)
}
