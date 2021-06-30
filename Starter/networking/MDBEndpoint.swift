//
//  MDBEndpoint.swift
//  Starter
//
//  Created by Thet Htun on 6/30/21.
//

import Foundation
import Alamofire

enum MDBEndpoint : URLConvertible {
   
    case searchMovie(_ page : String, _ query : String)
    case actorTVCredits(_ id : Int)
    case actorImages(_ id : Int)
    case actorDetail(_ id : Int)
    case trailerVideo(_ id : Int)
    case similarMovie(_ id : Int)
    case movieActors(_ id : Int)
    case movieDetails(_ id : Int)
    case seriesDetails(_ id : Int)
    case popularActors(_ page : Int)
    case topRatedMovies(_ page : Int)
    case movieGenres
    case popularTVSeries
    case upcomingMovie(_ page : Int)
    case popularMovie(_ page : Int)
    
    private var baseURL : String {
        return AppConstants.BaseURL
    }
    
        
    func asURL() throws -> URL {
        return url
    }
    
    var url : URL {
        let urlComponents = NSURLComponents(string: baseURL.appending(apiPath))
        
        if (urlComponents?.queryItems == nil) {
            urlComponents!.queryItems = [];
        }
        urlComponents!.queryItems!.append(contentsOf: [URLQueryItem(name: "api_key", value: AppConstants.apiKey)]);
        
        return urlComponents!.url!
    }
    
    private var apiPath : String {
        switch self {
        case .upcomingMovie(let page):
            return "/movie/upcoming?page=\(page)"
        case .popularMovie(let page):
            return "/movie/popular?page=\(page)"
        case .searchMovie(let page, let query):
            return "/search/movie?query=\(query)&page=\(page)"
        case .actorTVCredits(let id):
            return "/person/\(id)/tv_credits"
        case .actorImages(let id):
            return "/person/\(id)/images"
        case .actorDetail(let id):
            return "/person/\(id)"
        case .trailerVideo(let id):
            return "/movie/\(id)/videos"
        case .similarMovie(let id):
            return "/movie/\(id)/similar"
        case .movieActors(let id):
            return "/movie/\(id)/credits"
        case .movieDetails(let id):
            return "/movie/\(id)"
        case .seriesDetails(let id):
            return "/tv/\(id)"
        case .popularActors(let page):
            return "/person/popular?page=\(page)"
        case .topRatedMovies(let page):
            return "/movie/top_rated?page=\(page)"
        case .movieGenres:
            return "/genre/movie/list"
        case .popularTVSeries:
            return "/tv/popular"
        }
    }
}
