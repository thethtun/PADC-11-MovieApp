//
//  SearchModel.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

protocol SearchModel {
    func searchMovieByKeyword(query: String, page: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void)
}

class SearchModelImpl: BaseModel, SearchModel {
    
    static let shared : SearchModelImpl = SearchModelImpl()
    
    private override init() { }
    
    func searchMovieByKeyword(query: String, page: String, completion: @escaping (MDBResult<MovieListResponse>) -> Void) {
        networkAgent.searchMovieByKeyword(query: query, page: page, completion: completion)
    }
}
