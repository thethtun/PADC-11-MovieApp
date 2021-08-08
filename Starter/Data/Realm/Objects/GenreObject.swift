//
//  GenreObject.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

class GenreObject: Object {
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var name : String
    
    func toMovieGenre() -> MovieGenre {
        MovieGenre(id: id, name: name)
    }
}
