//
//  UserRepository.swift
//  Starter
//
//  Created by Thet Htun on 8/5/21.
//

import Foundation
import CoreData

protocol WatchListRepository {
    func getWatchListEntity(_ id : Int, completion: @escaping (WatchListEntity?) -> Void)
    func getWatchListItems(completion: @escaping ([MovieResult]) -> Void)
    func saveWatchList(id: Int, completion: @escaping (MDBResult<String>) -> Void)
    func removeWatchList(id: Int, completion: @escaping (MDBResult<String>) -> Void)
}

class WatchListRepositoryImpl: BaseRepository, WatchListRepository {
  
    static let shared : WatchListRepository = WatchListRepositoryImpl()
    
    private override init() { }
    
    private let movieRepository : MovieRepository = MovieRepositoryImpl.shared

    func getWatchListEntity(_ id: Int, completion: @escaping (WatchListEntity?) -> Void) {
        let fetchRequest = fetchRequestByMovieID(id)
        completion(try? coreData.context.fetch(fetchRequest).first)
    }
    
    func getWatchListItems(completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest : NSFetchRequest<WatchListEntity> = WatchListEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "insertedAt", ascending: false)
        ]
        
        let results = try? coreData.context.fetch(fetchRequest)
        let movieItems : [MovieResult] = results?
            .map { Int($0.movieId) }
            .map {
                let fetchRequest = movieRepository.getMovieFetchRequestById($0)
                let items = try? coreData.context.fetch(fetchRequest)
                return items?.first
            }
            .compactMap { $0 }
            .map {
                MovieEntity.toMovieResult(entity: $0)
            } ?? [MovieResult]()
            
        completion(movieItems)
    }
    
    
    func saveWatchList(id: Int, completion: @escaping (MDBResult<String>) -> Void) {
        movieRepository.getDetail(id: id) { [unowned self] (movieDetailResponse) in
            
            let entity = WatchListEntity(context: self.coreData.context)
            entity.movieId = Int64(id)
            entity.insertedAt = Date()
            
            self.coreData.saveContext()
            
            completion(.success("Added to Watch List"))
        }
    }
    
    func removeWatchList(id: Int, completion: @escaping (MDBResult<String>) -> Void) {
        let fetchRequest = fetchRequestByMovieID(id)

        if let watchListItems = try? coreData.context.fetch(fetchRequest),
           let item = watchListItems.first {
            
            coreData.context.delete(item)
            
            coreData.saveContext()
            
            completion(.success("Removed from Watch List"))
        } else {
            completion(.failure("Failed to remove from watch list"))
        }
        
    }
    
    private func fetchRequestByMovieID(_ id : Int) -> NSFetchRequest<WatchListEntity> {
        let fetchRequest : NSFetchRequest<WatchListEntity> = WatchListEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "movieId", "\(id)")
        
        return fetchRequest
    }
}
