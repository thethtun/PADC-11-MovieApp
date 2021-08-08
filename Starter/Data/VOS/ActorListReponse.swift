//
//  ActorListReponse.swift
//  Starter
//
//  Created by Thet Htun on 5/25/21.
//

import Foundation
import CoreData

public struct ActorListResponse : Codable {
    public let dates: Dates?
    public let page: Int?
    public let results: [ActorInfoResponse]?
    public let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


public struct ActorInfoResponse : Codable {
    let adult: Bool?
    let gender : Int?
    let id : Int?
    let knownFor : [MovieResult]?
    let knwonForDepartment: String?
    let name : String?
    let popularity : Double?
    let profilePath : String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownFor = "known_for"
        case knwonForDepartment = "known_for_department"
        case name
        case popularity
        case profilePath = "profile_path"
    }
    
    func toActorObject(contentTypeRepo : ContentTypeRepository) -> ActorObject {
        let object = ActorObject()
        object.adult = self.adult ?? false
        object.gender = self.gender ?? 0
        object.id = self.id!
        
        knownFor?.map {
            $0.toMovieObject(groupType: contentTypeRepo.getBelongsToTypeObject(type: .actorCredits))
        }.appendItems(to: object.knownFor)
        
        object.name = self.name
        object.popularity = self.popularity ?? 0
        object.profilePath = self.profilePath
        return object
    }
    
    func toActorEntity(context : NSManagedObjectContext, contentTypeRepo : ContentTypeRepository) -> ActorEntity {
        let entity = ActorEntity(context: context)
        entity.adult = self.adult ?? false
        entity.gender = Int32(self.gender ?? 0)
        entity.id = Int32(self.id!)
        
        knownFor?.forEach {
            let movie = $0.toMovieEntity(
                context: context,
                groupType: contentTypeRepo.getBelongsToTypeEntity(type: .actorCredits)
            )
            entity.addToCredits(movie)
        }
        
        entity.name = self.name
        entity.popularity = self.popularity ?? 0
        entity.profilePath = self.profilePath
        return entity
    }
}
