//
//  ActorModel.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation
import RxSwift

protocol ActorModel {
    var totalPageActorList : Int { get set }
    
    func getPopularPeople(page : Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void)
    func getPopularPeople(page: Int) -> Observable<[ActorInfoResponse]>
    func getActorGallery(id : Int, completion: @escaping (MDBResult<ActorProfileInfo>) -> Void)
    func getActorDetails(id : Int, completion: @escaping (MDBResult<ActorDetailInfo>) -> Void)
    func getTVCredits(id : Int, completion: @escaping (MDBResult<ActorTVCredits>) -> Void)
}

class ActorModelImpl: BaseModel, ActorModel {
    
    static let shared : ActorModel = ActorModelImpl()
    
    private override init() { }
    
    private let actorRepository : ActorRepository = ActorRepositoryImpl.shared
    
    var totalPageActorList : Int = 1
    
    func getActorGallery(id : Int, completion: @escaping (MDBResult<ActorProfileInfo>) -> Void) {
        networkAgent.getActorGallery(id: id, completion: completion)
    }
    
    func getActorDetails(id : Int, completion: @escaping (MDBResult<ActorDetailInfo>) -> Void) {
        networkAgent.getActorDetails(id: id) { (result) in
            switch result {
            case .success(let data):
                self.actorRepository.saveDetails(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.actorRepository.getDetails(id: id) { data in
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure("Couldn't find actor with id \(id)"))
                }
            }
            
        }
    }
    
    func getTVCredits(id : Int, completion: @escaping (MDBResult<ActorTVCredits>) -> Void) {
        networkAgent.getTVCredits(id: id, completion: completion)
    }
    
    func getPopularPeople(page: Int) -> Observable<[ActorInfoResponse]> {
        var networkResult = [ActorInfoResponse]()
        networkAgent.getPopularPeople(page: page) { (result) in
            switch result {
            case .success(let data):
                networkResult = data.results ?? [ActorInfoResponse]()
                self.actorRepository.save(list: data.results ?? [ActorInfoResponse]())
                self.totalPageActorList = data.totalPages ?? 1
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            if networkResult.isEmpty {
                /// Update Total Pages available to fetch
                self.actorRepository.getTotalPageActorList { self.totalPageActorList = $0 }
            }
        }
        
        return self.actorRepository.getList(page: page)
    }
    
    func getPopularPeople(page : Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void) {
        
        /**
         Which Total Page
         - Network Source - 100 pages
         - DB Source - 10 pages
         */
        
        var networkResult = [ActorInfoResponse]()
        networkAgent.getPopularPeople(page: page) { (result) in
            switch result {
            case .success(let data):
                networkResult = data.results ?? [ActorInfoResponse]()
                self.actorRepository.save(list: data.results ?? [ActorInfoResponse]())
                self.totalPageActorList = data.totalPages ?? 1
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.actorRepository.getList(page: page, type: .popularActors) {
                completion(.success($0))
            }
            
            if networkResult.isEmpty {
                /// Update Total Pages available to fetch
                self.actorRepository.getTotalPageActorList { self.totalPageActorList = $0 }
            }
        }
    }
    
}
