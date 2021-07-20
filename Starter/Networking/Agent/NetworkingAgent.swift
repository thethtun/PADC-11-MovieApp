//
//  NetworkingAgent.swift
//  Starter
//
//  Created by Thet Htun on 5/23/21.
//

import Foundation
import Alamofire

protocol MovieDBNetworkAgentProtocol {
    func searchMovieByKeyword(query: String, page: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getActorGallery(id : Int, completion: @escaping (MDBResult<ActorProfileInfo>) -> Void)
    func getTVCredits(id : Int, completion: @escaping (MDBResult<ActorTVCredits>) -> Void)
    func getActorDetails(id : Int, completion: @escaping (MDBResult<ActorDetailInfo>) -> Void)
    func getMovieTrailers(id : Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void)
    func getSimilarMovies(id : Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getMovieCreditById(id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void)
    func getSerieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
    func getMovieDetailById(id : Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void)
    func getPopularPeople(page : Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void)
    func getTopRatedMovieList(page : Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void)
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void)
}

struct MovieDBNetworkAgent : MovieDBNetworkAgentProtocol {
    
    static let shared = MovieDBNetworkAgent()
    
    private init() { }
    
    func searchMovieByKeyword(query: String, page: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.searchMovie(page, query))
            .responseDecodable(of: MovieListResponse.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
                }
            }
    }

    
    func getActorGallery(id : Int, completion : @escaping (MDBResult<ActorProfileInfo>) -> Void) {
        AF.request(MDBEndpoint.actorImages(id))
            .responseDecodable(of: ActorProfileInfo.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getTVCredits(id : Int, completion : @escaping (MDBResult<ActorTVCredits>) -> Void) {
        AF.request(MDBEndpoint.actorTVCredits(id))
            .responseDecodable(of: ActorTVCredits.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getActorDetails(id : Int, completion : @escaping (MDBResult<ActorDetailInfo>) -> Void) {
        AF.request(MDBEndpoint.actorDetail(id))
            .responseDecodable(of: ActorDetailInfo.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieTrailers(id : Int, completion : @escaping (MDBResult<MovieTrailerResponse>) -> Void) {
        AF.request(MDBEndpoint.trailerVideo(id))
            .responseDecodable(of: MovieTrailerResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getSimilarMovies(id : Int, completion : @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.similarMovie(id))
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieCreditById(id: Int, completion : @escaping (MDBResult<MovieCreditResponse>) -> Void) {
        AF.request(MDBEndpoint.movieActors(id))
            .responseDecodable(of: MovieCreditResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getSerieDetailById(id : Int, completion : @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        AF.request(MDBEndpoint.seriesDetails(id))
            .responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
               
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getMovieDetailById(id : Int, completion : @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        AF.request(MDBEndpoint.movieDetails(id))
            .responseDecodable(of: MovieDetailResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getPopularPeople(page : Int = 1, completion : @escaping (MDBResult<ActorListResponse>) -> Void) {
        AF.request(MDBEndpoint.popularActors(page))
            .responseDecodable(of: ActorListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getTopRatedMovieList(page : Int = 1, completion : @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.topRatedMovies(page))
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    
    
    
    func getPopularSeriesList(completion : @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.popularTVSeries)
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
            }
        }
    }
    
    func getPopularMovieList(completion : @escaping (MDBResult<MovieListResponse>) -> Void) {
        AF.request(MDBEndpoint.popularMovie(1))
            .responseDecodable(of: MovieListResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
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
    
    
    
    func getGenreList(completion : @escaping (MDBResult<MovieGenreList>) -> Void) {
//        let url = "\(AppConstants.BaseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)"
        AF.request(MDBEndpoint.movieGenres)
            .responseDecodable(of: MovieGenreList.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                //Handle Error
                completion(.failure(handleError(response, error, MDBCommonResponseError.self)))
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
    fileprivate func handleError<T, E: MDBErrorModel>(
        _ response: DataResponse<T, AFError>,
        _ error: (AFError),
        _ errorBodyType : E.Type) -> String {
        
        
        var respBody : String = ""
        
        var serverErrorMessage : String?
        
        var errorBody : E?
        if let respData = response.data {
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            
            errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        /// 2 - Extract debug info
        let respCode : Int = response.response?.statusCode ?? 0
        
        let sourcePath = response.request?.url?.absoluteString ?? "no url"
        
        
        /// 1 - Essential debug info
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
        
        /// 4 - Client display
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
















