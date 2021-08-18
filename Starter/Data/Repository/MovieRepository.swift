//
//  MovieRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation
import CoreData
import RealmSwift

protocol MovieRepository {
    func getDetail(id : Int, completion: @escaping (MovieDetailResponse?) -> Void)
    func getMovieResult(id : Int, completion: @escaping (MovieResult?) -> Void)
    func saveDetail(data: MovieDetailResponse)
    func saveList(type: MovieSerieGroupType, data : MovieListResponse)
    func saveSimilarContent(id: Int, data: [MovieResult])
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void)
    func saveCasts(id : Int, data: [MovieCast])
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void)
    func getMovieFetchRequestById(_ id : Int) -> NSFetchRequest<MovieEntity>
    
    func testDummy()
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
    
    static let shared : MovieRepository = MovieRepositoryImpl()
    
    private override init() {
    }
    
    let contentTypeRepo : ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    func saveCasts(id : Int, data: [MovieCast]) {
        if let movieObject = realmInstance.db.object(ofType: MovieObject.self, forPrimaryKey: id) {
           
            try! realmInstance.db.write {
                let newMovieObject = realmInstance.db.create(MovieObject.self, value: movieObject, update: .modified)
                
                data.map {
                    $0.convertToActorInfoResponse()
                }.map { (source) -> ActorObject in 
                    let actorObject = source.toActorObject(contentTypeRepo: contentTypeRepo)
                    let newActorObject = realmInstance.db.create(ActorObject.self, value: actorObject, update: .modified)
                    return newActorObject
                }.appendItems(to: newMovieObject.actors)
                
                realmInstance.db.add(newMovieObject)
            }
            
        }
    }
    
    func getCasts(id: Int, completion: @escaping ([MovieCast]) -> Void) {
        if let movieObject = realmInstance.db.object(ofType: MovieObject.self, forPrimaryKey: id) {
            completion(movieObject.actors.map { $0.toMovieCast() })
        } else {
            completion([MovieCast]())
        }
    }
    
    
    func saveSimilarContent(id: Int, data: [MovieResult]) {
        if let movieObject = realmInstance.db.object(ofType: MovieObject.self, forPrimaryKey: id) {
            
            try! realmInstance.db.write {
                let newMovieObject = realmInstance.db.create(MovieObject.self, value: movieObject, update: .modified)
                data.map {
                    
                    realmInstance.db.create(
                        MovieObject.self,
                        value: $0.toMovieObject(groupType: contentTypeRepo.getBelongsToTypeObject(type: .actorCredits)),
                        update: .modified)
                    
                }.appendItems(to: newMovieObject.similarMovies)
                
                realmInstance.db.add(newMovieObject, update: .modified)
            }
            
        }
    }
    
    func getSimilarContent(id: Int, completion: @escaping ([MovieResult]) -> Void) {
        if let movieObject = realmInstance.db.object(ofType: MovieObject.self, forPrimaryKey: id) {
            completion(movieObject.similarMovies.map { $0.toMovieResult() })
        } else {
            completion([MovieResult]())
        }
    }
    
    
    func saveDetail(data: MovieDetailResponse) {
        let object = data.toMovieObject()
        testObjects()
        try! realmInstance.db.write {
            realmInstance.db.add(object, update: .modified)
        }
    }
    
    func getDetail(id : Int, completion: @escaping (MovieDetailResponse?) -> Void) {
        guard let movieObject = realmInstance.db.object(ofType: MovieObject.self, forPrimaryKey: id) else {
            completion(nil)
            return
        }
        completion(movieObject.toMovieDetailResponse())
    }
    
    func getMovieResult(id : Int, completion: @escaping (MovieResult?) -> Void) {
        guard let movieObject = realmInstance.db.object(ofType: MovieObject.self, forPrimaryKey: id) else {
            completion(nil)
            return
        }
        completion(movieObject.toMovieResult())
    }
    
    func saveList(type: MovieSerieGroupType, data : MovieListResponse) {
        let objects = List<MovieObject>()
        data.results?.map {
            $0.toMovieObject(groupType: contentTypeRepo.getBelongsToTypeObject(type: type))
        }.forEach {
            objects.append($0)
        }
        
        
        try! realmInstance.db.write {
            realmInstance.db.add(objects, update: .modified)
        }
        
    }
    
    func getMovieFetchRequestById(_ id : Int) -> NSFetchRequest<MovieEntity> {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(id)")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        return fetchRequest
    }
    
    
    func testDummy() {
        
    }
    
    
    func testBackgroundProcess() {
        /// This code shouldn't block the UI.
        self.coreData.persistentContainer.performBackgroundTask { (context) in
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            var dummyLanguages = [SpokenLanguage]()
            for i in 1...5000 {
                dummyLanguages.append(SpokenLanguage(englishName: nil, iso639_1: nil, name: "test_\(i)"))
            }
            
            // insert a bunch of objects - backgroundContext
            dummyLanguages.forEach {
                let entity = SpokenLanguageEntity(context: context)
                entity.englishName = $0.englishName
                entity.iso639_1 = $0.iso639_1
                entity.name = $0.name
            }
            
            context.perform {
                try! context.save()
            }
        }
        
    }
    
    
    func testViewContext() {
        let context = self.coreData.context

        var dummyLanguages = [SpokenLanguage]()
        for i in 1...5000 {
            dummyLanguages.append(SpokenLanguage(englishName: nil, iso639_1: nil, name: "test_\(i)"))
        }

        // insert a bunch of objects - backgroundContext
        dummyLanguages.forEach {
            let entity = SpokenLanguageEntity(context: context)
            entity.englishName = $0.englishName
            entity.iso639_1 = $0.iso639_1
            entity.name = $0.name
        }


        context.perform {
            try! context.save()
        }
    }
}





class Department : Object {
    @Persisted(primaryKey: true)
    var name : String
    
    @Persisted
    var employees: List<Employee>

    convenience init(name : String, employees: List<Employee>) {
        self.init()
        self.name = name
        self.employees = employees
    }
}

class Employee : Object {
    @Persisted(primaryKey: true)
    var name : String
    
    @Persisted
    var workHours : Int
    
    convenience init(name : String, workHours: Int) {
        self.init()
        self.name = name
        self.workHours = workHours
    }
}

func testObjects() {
    
    let data : List<Department> = [
        Department(name: "HR Department", employees: [
                    Employee(name: "A", workHours: 30),
                    Employee(name: "B", workHours: 28),
                   ].toRealmList()),
        Department(name: "Business Department", employees: [
                    Employee(name: "C", workHours: 12),
                    Employee(name: "D", workHours: 10),
                    Employee(name: "E", workHours: 8),
                    Employee(name: "F", workHours: 12),
                    Employee(name: "G", workHours: 9),
                   ].toRealmList()),
        Department(name: "Tech Department", employees: [
                    Employee(name: "H", workHours: 83),
                    Employee(name: "I", workHours: 85),
                   ].toRealmList()),
        Department(name: "Customer Service Department",employees: [
                    Employee(name: "J", workHours: 31),
                    Employee(name: "K", workHours: 45),
                    Employee(name: "L", workHours: 34),
                   ].toRealmList()),
        Department(name: "Marketing Department", employees: [
                    Employee(name: "M", workHours: 23),
                    Employee(name: "N", workHours: 20),
                   ].toRealmList()),
    ].toRealmList()
    
    let realm = try! Realm()
    try! realm.write {
        realm.add(data, update: .modified)
    }
    
    
    realm.objects(Department.self).filter("employees.@sum.workHours > 100").forEach{ print($0.name) }
    
}
