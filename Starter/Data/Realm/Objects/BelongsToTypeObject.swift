//
//  BelongsToTypeObject.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

class BelongsToTypeObject: Object {
    @Persisted(primaryKey: true)
    var name: String
    
    @Persisted(originProperty: "belongsToType")
    var movies: LinkingObjects<MovieObject>
}
