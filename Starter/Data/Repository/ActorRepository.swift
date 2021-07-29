//
//  ActorRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/29/21.
//

import Foundation
import CoreData

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
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        
        let results = try? coreData.context.fetch(fetchRequest)
        if let detailEntity = results?.first {
            completion(ActorEntity.toActorInfoDetail(entity: detailEntity))
        } else {
            completion(nil)
        }

    }
    
    func saveDetails(data : ActorDetailInfo) {
        let _ = data.toActorEntity(context: coreData.context)
        coreData.saveContext()
    }
    
    func getList(page: Int, type: ActorGroupType, completion: @escaping ([ActorInfoResponse]) -> Void) {
        
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true),
            NSSortDescriptor(key: "popularity", ascending: false),
        ]
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = (pageSize * page) - pageSize
        
        do {
            let items = try coreData.context.fetch(fetchRequest)
            completion(items.map { ActorEntity.toActorInfoResponse(entity: $0) })
        } catch {
            print("\(#function) \(error.localizedDescription)")
            completion([ActorInfoResponse]())
        }
        
    }
    
    func save(list : [ActorInfoResponse]) {
        list.forEach {
            let _ = $0.toActorEntity(context: coreData.context, contentTypeRepo: contentTypeRepository)
        }
        
        coreData.saveContext()
    }
    
    func getTotalPageActorList(completion: @escaping (Int) -> Void) {
        let fetchRequest : NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        let totalItems = (try? coreData.context.count(for: fetchRequest)) ?? 1
        let totalPages = totalItems/pageSize
        completion(totalPages)
    }
    
}
