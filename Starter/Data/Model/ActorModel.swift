//
//  ActorModel.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

protocol ActorModel {
    func getActorGallery(id : Int, completion: @escaping (MDBResult<ActorProfileInfo>) -> Void)
    func getActorDetails(id : Int, completion: @escaping (MDBResult<ActorDetailInfo>) -> Void)
    func getTVCredits(id : Int, completion: @escaping (MDBResult<ActorTVCredits>) -> Void)
}

class ActorModelImpl: BaseModel, ActorModel {
    
    static let shared : ActorModelImpl = ActorModelImpl()
    
    private override init() { }
    
    func getActorGallery(id : Int, completion: @escaping (MDBResult<ActorProfileInfo>) -> Void) {
        networkAgent.getActorGallery(id: id, completion: completion)
    }
    
    func getActorDetails(id : Int, completion: @escaping (MDBResult<ActorDetailInfo>) -> Void) {
        networkAgent.getActorDetails(id: id, completion: completion)
    }
    
    func getTVCredits(id : Int, completion: @escaping (MDBResult<ActorTVCredits>) -> Void) {
        networkAgent.getTVCredits(id: id, completion: completion)
    }
    
}
