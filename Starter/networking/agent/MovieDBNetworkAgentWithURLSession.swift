//
//  MovieDBNetworkAgentWithURLSession.swift
//  Starter
//
//  Created by Thet Htun on 7/1/21.
//

import Foundation


class MovieDBNetworkAgentWithURLSession : MovieDBNetworkAgentProtocol {
    
    static let shared = MovieDBNetworkAgentWithURLSession()
    
    private init() { }
    
    func searchMovieByKeyword(query: String, page: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getActorGallery(id: Int, completion: @escaping (MDBResult<ActorProfileInfo>) -> Void) {
        
    }
    
    func getTVCredits(id: Int, completion: @escaping (MDBResult<ActorTVCredits>) -> Void) {
        
    }
    
    func getActorDetails(id: Int, completion: @escaping (MDBResult<ActorDetailInfo>) -> Void) {
        
    }
    
    func getMovieTrailers(id: Int, completion: @escaping (MDBResult<MovieTrailerResponse>) -> Void) {
        
    }
    
    func getSimilarMovies(id: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getMovieCreditById(id: Int, completion: @escaping (MDBResult<MovieCreditResponse>) -> Void) {
        
    }
    
    func getSerieDetailById(id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        
    }
    
    func getMovieDetailById(id: Int, completion: @escaping (MDBResult<MovieDetailResponse>) -> Void) {
        
    }
    
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<ActorListResponse>) -> Void) {
        
    }
    
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getGenreList(completion: @escaping (MDBResult<MovieGenreList>) -> Void) {
        let url = URL(string: "\(AppConstants.BaseURL)/genre/movie/list?api_key=\(AppConstants.apiKey)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET" //case sensitive
        urlRequest.allHTTPHeaderFields = ["key1": "value1", "key2": "value2"]
        urlRequest.setValue("value3", forHTTPHeaderField: "key3")
        
        let session = URLSession.shared

        session.dataTask(with: urlRequest) { (data, response, error) in
            let genreList : MovieGenreList = try! JSONDecoder().decode(MovieGenreList.self, from: data!)
            completion(.success(genreList))
//            print(genreList.genres.count)
        }.resume()
    }
    
    func getPopularSeriesList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getPopularMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    func getUpcomingMovieList(completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        
    }
    
    
}
