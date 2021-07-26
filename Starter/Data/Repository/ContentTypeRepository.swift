//
//  ContentTypeRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/26/21.
//

import Foundation
import CoreData

protocol ContentTypeRepository {
    func save(name : String) -> BelongsToTypeEntity
    func getMoviesOrSeries(type : MovieSerieGroupType, completion: @escaping ([MovieEntity]) -> Void)
    func getBelongsToTypeEntity(type : MovieSerieGroupType) -> BelongsToTypeEntity
}

class ContentTypeRepositoryImpl: BaseRepository, ContentTypeRepository {
    
    static let shared : ContentTypeRepository = ContentTypeRepositoryImpl()
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    
    private override init() {
        super.init()
        
        initializeData()
    }
    
    private func initializeData() {
        // Process Existing Data
        let fetchRequest : NSFetchRequest<BelongsToTypeEntity> = BelongsToTypeEntity.fetchRequest()
        do {
            let dataSource = try self.coreData.context.fetch(fetchRequest)
            
            if dataSource.isEmpty {
                //insert initial data
                MovieSerieGroupType.allCases.forEach {
                    save(name: $0.rawValue)
                }
            } else {
                //map existing data
                dataSource.forEach {
                    if let key = $0.name {
                        contentTypeMap[key] = $0
                    }
                }
            }
            
        } catch {
            print(error)
        }
        
    }
    
    func getMoviesOrSeries(type : MovieSerieGroupType, completion: @escaping ([MovieEntity]) -> Void) {
        if let entity = contentTypeMap[type.rawValue],
           let movies = entity.movies,
           let itemSet = movies as? Set<MovieEntity>{
            completion(Array(itemSet.sorted(by: { (first, second) -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()

                return firstDate.compare(secondDate) == .orderedDescending

            })))
        } else {
            completion([MovieEntity]())
        }
    }
    
    @discardableResult
    func save(name : String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        
        contentTypeMap[name] = entity
        
        coreData.saveContext()
        
        return entity
    }
    
    func getBelongsToTypeEntity(type : MovieSerieGroupType) -> BelongsToTypeEntity {
        if let entity = contentTypeMap[type.rawValue] {
            return entity
        }
        
        return save(name: type.rawValue)
    }
}
