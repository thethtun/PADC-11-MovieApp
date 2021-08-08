//
//  BelongsToCollectionObject.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

class BelongToCollectionObject: Object {
    
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var backdropPath : String?
    
    @Persisted
    var name : String?
    
    @Persisted
    var posterPath : String?
    
    
    func toBelongsToCollection() -> BelongsToCollection {
        BelongsToCollection(
            backdropPath:backdropPath,
            id: id,
            name:name,
            posterPath:posterPath)
    }
}
