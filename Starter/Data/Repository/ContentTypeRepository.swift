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
    func save(name: String) -> BelongsToTypeObject
    func getMoviesOrSeries(type : MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void)
    func getBelongsToTypeEntity(type : MovieSerieGroupType) -> BelongsToTypeEntity
    func getBelongsToTypeObject(type : MovieSerieGroupType) -> BelongsToTypeObject
}

class ContentTypeRepositoryImpl: BaseRepository, ContentTypeRepository {
    
    static let shared : ContentTypeRepository = ContentTypeRepositoryImpl()
    
    private var contentTypeMap = [String: BelongsToTypeObject]()
    
    private override init() {
        super.init()
        
        initializeData()
    }
    
    private func initializeData() {
        /// Process Existing Data
        
        let dataSource = realmInstance.db.objects(BelongsToTypeObject.self)
        
        if dataSource.isEmpty {
            /// Insert initial data
            MovieSerieGroupType.allCases.forEach {
                let _ : BelongsToTypeObject = save(name: $0.rawValue)
            }
        } else {
            /// Map existing data
            dataSource.forEach {
                contentTypeMap[$0.name] = $0
            }
        }
    }
    
    func getMoviesOrSeries(type : MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
        if let object = contentTypeMap[type.rawValue] {
            let items = object.movies.sorted(by: { (first, second) -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
                
                return firstDate.compare(secondDate) == .orderedDescending
            }).map {
                $0.toMovieResult()
            }
            completion(items)
        } else {
            completion([MovieResult]())
        }
    }
    
    @discardableResult
    func save(name : String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
//        entity.name = name
//
//        contentTypeMap[name] = entity
//
//        coreData.saveContext()
//
        return entity
    }
    
    @discardableResult
    func save(name: String) -> BelongsToTypeObject {
        let object = BelongsToTypeObject()
        object.name = name
        
        contentTypeMap[name] = object
        
        try! realmInstance.db.write {
            realmInstance.db.add(object, update: .modified)
        }
        return object
    }
    
    func getBelongsToTypeEntity(type : MovieSerieGroupType) -> BelongsToTypeEntity {
//        if let entity = contentTypeMap[type.rawValue] {
//            return entity
//        }
//
        return save(name: type.rawValue)
    }
    
    func getBelongsToTypeObject(type : MovieSerieGroupType) -> BelongsToTypeObject {
        if let object = contentTypeMap[type.rawValue] {
            return object
        }
        
        return save(name: type.rawValue)
    }
}
