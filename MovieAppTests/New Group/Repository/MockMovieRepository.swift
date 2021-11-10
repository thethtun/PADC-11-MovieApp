//
//  MockContentTypeRepository.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import Foundation
@testable import Starter
import CoreData

class MockMovieRepository: MovieRepository {
    
    var isSaveListCalled: Bool = false
    var savedMovieSerieGroupType : MovieSerieGroupType?
    var lastSavedMovieListResponse: MovieListResponse?
    
    func getDetail(id: Int, completion: @escaping (MovieDetailResponse?) -> Void) {
        completion(nil)
    }
    
    func getMovieResult(id: Int, completion: @escaping (MovieResult?) -> Void) {
        completion(nil)
    }
    
    func saveDetail(data: MovieDetailResponse) {
        
    }
    
    func saveList(type: MovieSerieGroupType, data: MovieListResponse) {
        isSaveListCalled = true
        savedMovieSerieGroupType = type
        lastSavedMovieListResponse = data
    }
    
    func saveSimilarContent(id: Int, data: [MovieResult]) {
        
    }
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        completion([MovieResult]())
    }
    
    func saveCasts(id: Int, data: [MovieCast]) {
        
    }
    
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void) {
        completion([MovieCast]())
    }
    
    func getMovieFetchRequestById(_ id: Int) -> NSFetchRequest<MovieEntity> {
        return MovieEntity.fetchRequest()
    }
    
    
}
