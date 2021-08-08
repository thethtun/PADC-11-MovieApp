//
//  BelongsToCollection.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import CoreData

// MARK: - Belongs To Collection
public struct BelongsToCollection : Codable {
    public let backdropPath : String?
    public let id : Int?
    public let name : String?
    public let posterPath : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }

    func toBelongsToCollectionObject() -> BelongToCollectionObject {
        let object = BelongToCollectionObject()
        object.backdropPath = self.backdropPath
        object.id = self.id!
        object.name = self.name
        object.posterPath = self.posterPath
        return object
    }
    
    func toBelongsToCollectionEntity(context: NSManagedObjectContext) -> BelongsToCollectionEntity {
        let entity = BelongsToCollectionEntity(context: context)
        entity.backdropPath = self.backdropPath
        entity.id = Int32(self.id!)
        entity.name = self.name
        entity.posterPath = self.posterPath
        return entity
    }
}







