//
//  MovieRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation
import CoreData

protocol MovieRepository {
    func get(type: MovieSerieGroupType, completion: @escaping ([MovieEntity]) -> Void)
    func save(type: MovieSerieGroupType, data : MovieListResponse)
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
   
    static let shared : MovieRepositoryImpl = MovieRepositoryImpl()
    
    private override init() { }
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    let contentTypeRepo : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    func get(type: MovieSerieGroupType, completion: @escaping ([MovieEntity]) -> Void) {
        let fetchRequest = MovieEntity.get(type: type, context: self.coreData.context)
        
        do {
            let dataSource = try self.coreData.context.fetch(fetchRequest)
            completion(dataSource)
        } catch {
            completion([MovieEntity]())
        }
    }
    
    func save(type: MovieSerieGroupType, data : MovieListResponse) {
        data.results?.forEach {
            $0.toMovieEntity(
                context: self.coreData.context,
                groupType: contentTypeRepo.getBelongsToTypeEntity(type: type)
            )
        }
        self.coreData.saveContext()
    }
    
  
}

