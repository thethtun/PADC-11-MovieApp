//
//  MovieRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation
import CoreData

protocol MovieRepository {
    func getDetail(id : Int, completion: @escaping (MovieDetailResponse?) -> Void)
    func saveDetail(data: MovieDetailResponse)
    func saveList(type: MovieSerieGroupType, data : MovieListResponse)
    func saveSimilarContent(id: Int, data: [MovieResult])
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void)
    func saveCasts(id : Int, data: [MovieCast])
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void)
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
    
    static let shared : MovieRepository = MovieRepositoryImpl()
    
    private override init() { }
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    let contentTypeRepo : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    func saveCasts(id : Int, data: [MovieCast]) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            data.map {
                $0.convertToActorInfoResponse()
            }.map {
                $0.toActorEntity(context: coreData.context, contentTypeRepo: contentTypeRepo)
            }.forEach {
                firstItem.addToCasts($0)
            }
            coreData.saveContext()
        }
    }
    
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first,
            let actorEntites = (firstItem.casts as? Set<ActorEntity>) {
            completion(
                actorEntites.map {
                    ActorEntity.toMovieCast(entity: $0)
                }
            )
        }
    }
    
    
    func saveSimilarContent(id: Int, data: [MovieResult]) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            data.map {
                $0.toMovieEntity(
                    context: coreData.context,
                    groupType: contentTypeRepo.getBelongsToTypeEntity(type: .actorCredits)
                )
            }.forEach {
                firstItem.addToSimilarMovies($0)
            }
            coreData.saveContext()
        }
    }
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            completion(
                (firstItem.similarMovies as? Set<MovieEntity>)?.map {
                    MovieEntity.toMovieResult(entity: $0)
                } ?? [MovieResult]()
            )
        }
    }
    
    
    func saveDetail(data: MovieDetailResponse) {
        let _ = data.toMovieEntity(context: coreData.context)
        coreData.saveContext()
    }
    
    func getDetail(id : Int, completion: @escaping (MovieDetailResponse?) -> Void) {
        let fetchRequest : NSFetchRequest<MovieEntity> = getMovieFetchRequestById(id)
        
        if let items = try? coreData.context.fetch(fetchRequest),
           let firstItem = items.first {
            completion(MovieEntity.toMovieDetailResponse(entity: firstItem))
        } else {
            completion(nil)
        }
    }
    
    func saveList(type: MovieSerieGroupType, data : MovieListResponse) {
        data.results?.forEach {
            $0.toMovieEntity(
                context: self.coreData.context,
                groupType: contentTypeRepo.getBelongsToTypeEntity(type: type)
            )
        }
        self.coreData.saveContext()
    }
    
    private func getMovieFetchRequestById(_ id : Int) -> NSFetchRequest<MovieEntity> {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return fetchRequest
    }
    
}










//func testDummy() {
//    let viewContext = coreData.persistentContainer.viewContext
//
//    let backgroundContext = self.coreData.persistentContainer.newBackgroundContext()
//
//    var dummyLanguages = [SpokenLanguage]()
//    for i in 1..<5 {
//        dummyLanguages.append(SpokenLanguage(englishName: nil, iso639_1: nil, name: "mm_\(i)"))
//    }
//
//    // insert a bunch of objects - backgroundContext
//    dummyLanguages.forEach {
//        let entity = SpokenLanguageEntity(context: viewContext)
//        entity.englishName = $0.englishName
//        entity.iso639_1 = $0.iso639_1
//        entity.name = $0.name
//    }
//
//    viewContext.perform {
//        try! viewContext.save()
//    }
//
//    DispatchQueue.global(qos: .userInitiated).async {
//
//
////
//
//
////            let fetchRequest : NSFetchRequest<SpokenLanguageEntity> = SpokenLanguageEntity.fetchRequest()
//
//
//        // fetch objects using bg context - viewContext
////            let results = try? viewContext.fetch(fetchRequest)
////            print("lang items count => \(results?.count ?? 0)")
//
//
//        // delete inserted objects - backgroundContext
////            let items = try? backgroundContext.fetch(fetchRequest)
////            items?.forEach {
////                backgroundContext.delete($0)
////            }
////
////            backgroundContext.perform {
////                try! backgroundContext.save()
////            }
//    }
//
