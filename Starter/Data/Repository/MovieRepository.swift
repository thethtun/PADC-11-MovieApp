//
//  MovieRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

protocol MovieRepository {
    func get(type: MovieGroupType, completion: @escaping ([MovieEntity]) -> Void)
    func save(type: MovieGroupType, data : MovieListResponse)
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
    
    static let shared : MovieRepositoryImpl = MovieRepositoryImpl()
    
    private override init() { }
    
    func get(type: MovieGroupType, completion: @escaping ([MovieEntity]) -> Void) {
        let fetchRequest = MovieEntity.get(type: type, context: self.coreData.context)
        
        do {
            let dataSource = try self.coreData.context.fetch(fetchRequest)
            completion(dataSource)
        } catch {
            completion([MovieEntity]())
        }
    }
    
    func save(type: MovieGroupType, data : MovieListResponse) {
        data.results?.forEach { let _ = $0.toMovieEntity(context: self.coreData.context, groupType: type) }
        self.coreData.saveContext()
    }
}

