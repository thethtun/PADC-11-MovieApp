//
//  ActorRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/29/21.
//

import Foundation
import CoreData
import RealmSwift

protocol ActorRepository {
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void)
    func save(list : [ActorInfoResponse])
    func saveDetails(data : ActorDetailInfo)
    func getDetails(id : Int, completion: @escaping (ActorDetailInfo?) -> Void)
    func getTotalPageActorList(completion: @escaping (Int) -> Void)
}

class ActorRepositoryImpl: BaseRepository, ActorRepository {
   
    static let shared : ActorRepository = ActorRepositoryImpl()
    
    private override init() { }
    
    private let contentTypeRepository : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    private let pageSize : Int = 20
    
    func getDetails(id: Int, completion: @escaping (ActorDetailInfo?) -> Void) {
        completion(
            realmInstance.db.object(ofType: ActorObject.self, forPrimaryKey: id)?.toActorInfoDetail()
        )
    }
    
    func saveDetails(data : ActorDetailInfo) {
        let object = data.toActorObject()
        
        try! realmInstance.db.write {
            realmInstance.db.add(object, update: .modified)
        }
    }
    
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void) {
        let items : [ActorInfoResponse] = realmInstance.db.objects(ActorObject.self)
            .sorted(byKeyPath: "insertedAt", 
                    ascending: false)
            .sorted(byKeyPath: "popularity", ascending: false)
            .sorted(byKeyPath: "name", ascending: true)
            .map { $0.toActorInfoResponse() }
        
        completion(items)
        
        
    }
    
    func save(list : [ActorInfoResponse]) {
        
        let objects = List<ActorObject>()
        list.map { $0.toActorObject(contentTypeRepo: contentTypeRepository) }
            .forEach {
                objects.append($0)
            }
    
        try! realmInstance.db.write {
            realmInstance.db.add(objects, update: .modified)
        }
    }
    
    func getTotalPageActorList(completion: @escaping (Int) -> Void) {
//        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
//        let totalItems = (try? coreData.context.count(for: fetchRequest)) ?? 1
//        var totalPages = totalItems/pageSize
//        if totalItems % pageSize > 0 { totalPages += 1 }
//        completion(totalPages)
        
        completion(1) // Fetching all data for now.
    }
    
}
