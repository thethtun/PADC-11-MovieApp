//
//  MockContentTypeRepository.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import Foundation
@testable import Starter
import CoreData

class MockContentTypeRepository: ContentTypeRepository {
    
    func save(name: String) -> BelongsToTypeEntity {
        BelongsToTypeEntity()
    }
    
    func save(name: String) -> BelongsToTypeObject {
        BelongsToTypeObject()
    }
    
    func getMoviesOrSeries(type: MovieSerieGroupType, completion: @escaping ([MovieResult]) -> Void) {
        completion([MovieResult]())
    }
    
    func getBelongsToTypeObject(type: MovieSerieGroupType) -> BelongsToTypeObject {
        BelongsToTypeObject()
    }
    
   
    
}
