//
//  BelongsToCollectionEntityExtension.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

extension BelongsToCollectionEntity {
    
    static func toBelongsToCollection(entity: BelongsToCollectionEntity?) -> BelongsToCollection {
        BelongsToCollection(
            backdropPath: entity?.backdropPath,
            id: Int(entity?.id ?? 0),
            name: entity?.name,
            posterPath: entity?.posterPath)
    }
}
