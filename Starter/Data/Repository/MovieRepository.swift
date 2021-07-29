//
//  MovieRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation
import CoreData

protocol MovieRepository {
    func get(type: MovieSerieGroupType, completion: @escaping ([MovieEntity]) -> Void)
    func save(type: MovieSerieGroupType, data : MovieListResponse)
    func testDummy()
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
   
    static let shared : MovieRepository = MovieRepositoryImpl()
    
    private override init() { }
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    let contentTypeRepo : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    func get(type: MovieSerieGroupType, completion: @escaping ([MovieEntity]) -> Void) {
        let fetchRequest = MovieEntity.get(type: type, context: self.coreData.context)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "releaseDate", ascending: false),
            NSSortDescriptor(key: "voteAverage", ascending: false),
        ]
        
        do {
            let dataSource = try self.coreData.context.fetch(fetchRequest)
            completion(dataSource)
        } catch {
            completion([MovieEntity]())
        }
    }
    
    func save(type: MovieSerieGroupType, data : MovieListResponse) {
        data.results?.forEach {
            $0.toMovieEntity(
                context: self.coreData.context,
                groupType: contentTypeRepo.getBelongsToTypeEntity(type: type)
            )
        }
        self.coreData.saveContext()
    }
 
    func testDummy() {
        let viewContext = coreData.persistentContainer.viewContext
        
        let backgroundContext = self.coreData.persistentContainer.newBackgroundContext()
        
        var dummyLanguages = [SpokenLanguage]()
        for i in 1..<5 {
            dummyLanguages.append(SpokenLanguage(englishName: nil, iso639_1: nil, name: "mm_\(i)"))
        }

        // insert a bunch of objects - backgroundContext
        dummyLanguages.forEach {
            let entity = SpokenLanguageEntity(context: viewContext)
            entity.englishName = $0.englishName
            entity.iso639_1 = $0.iso639_1
            entity.name = $0.name
        }

        viewContext.perform {
            try! viewContext.save()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
           
           
//
            
            
//            let fetchRequest : NSFetchRequest<SpokenLanguageEntity> = SpokenLanguageEntity.fetchRequest()
            
            
            // fetch objects using bg context - viewContext
//            let results = try? viewContext.fetch(fetchRequest)
//            print("lang items count => \(results?.count ?? 0)")
            
            
            // delete inserted objects - backgroundContext
//            let items = try? backgroundContext.fetch(fetchRequest)
//            items?.forEach {
//                backgroundContext.delete($0)
//            }
//
//            backgroundContext.perform {
//                try! backgroundContext.save()
//            }
        }
        
        
    }
}

