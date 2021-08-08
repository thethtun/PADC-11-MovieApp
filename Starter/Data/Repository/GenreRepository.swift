//
//  GenreRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/29/21.
//

import Foundation
import CoreData
import RealmSwift

protocol GenreRepository {
    func get(completion: @escaping ([MovieGenre]) -> Void)
    func save(data : MovieGenreList)
}

class GenreRepositoryImpl: BaseRepository, GenreRepository {
    
    static let shared : GenreRepository = GenreRepositoryImpl()
    
    private override init() { }
    
    func get(completion: @escaping ([MovieGenre]) -> Void) {
        
        let items : [MovieGenre] = realmInstance.db.objects(GenreObject.self)
            .sorted(byKeyPath: "name", ascending: true)
            .map { $0.toMovieGenre() }
        
        completion(items)
        
    }
    
    func save(data : MovieGenreList) {
    
        let objects = List<GenreObject>()
        data.genres.map {
            $0.toGenreObject()
        }.forEach {
            objects.append($0)
        }
        
        try! realmInstance.db.write {
            realmInstance.db.add(objects, update: .modified)
        }
        
    }
    
    
}
