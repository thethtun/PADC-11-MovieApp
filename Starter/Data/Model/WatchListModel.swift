//
//  UserModel.swift
//  Starter
//
//  Created by Thet Htun on 8/5/21.
//

import Foundation

protocol WatchListModel {
    func checkIfItemInWatchList(id: Int, completion: @escaping (Bool) -> Void)
    func getWatchListItems(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func saveWatchList(id: Int, completion: ((MDBResult<String>) -> Void)?)
    func removeWatchList(id: Int, completion: ((MDBResult<String>) -> Void)?)
}

class WatchListModelImpl: BaseModel, WatchListModel {
    
    static let shared : WatchListModel = WatchListModelImpl()
    
    private override init() { }
    
    private let watchListRepository : WatchListRepository = WatchListRepositoryImpl.shared
    
    func checkIfItemInWatchList(id: Int, completion: @escaping (Bool) -> Void) {
        watchListRepository.getWatchListEntity(id) { (item) in
            completion(item != nil)
        }
    }
    
    func getWatchListItems(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        watchListRepository.getWatchListItems { (results) in
            completion(.success(results))
        }
    }
    
    func saveWatchList(id: Int, completion: ((MDBResult<String>) -> Void)? = nil) {
        watchListRepository.saveWatchList(id: id) { (results) in
            completion?(results)
        }
    }
    
    func removeWatchList(id: Int, completion: ((MDBResult<String>) -> Void)? = nil) {
        watchListRepository.removeWatchList(id: id) { (results) in
            completion?(results)
        }
    }
    
}
