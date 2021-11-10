//
//  MockGenreRepository.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import Foundation
@testable import Starter
import RxSwift


class MockGenreRepository: GenreRepository {
    
    func get() -> Observable<[MovieGenre]> {
        Observable.just([MovieGenre]())
    }
    
    func get(completion: @escaping ([MovieGenre]) -> Void) {
        completion([MovieGenre]())
    }
    
    func save(data: MovieGenreList) {
        
    }
    
    
}
