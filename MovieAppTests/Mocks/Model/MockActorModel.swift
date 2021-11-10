//
//  MockActorModel.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import Foundation
@testable import Starter
import RxSwift

class MockActorModel: ActorModel {
    
    var totalPageActorList: Int = 1
    
    private var popularPeopleList: [ActorInfoResponse] = []
    
    init() {
        let actorDataJson = try! Data(contentsOf: MovieMockData.ActorList.popularPeopleListJSONUrl)
        let actorResponseData = try! JSONDecoder().decode(ActorListResponse.self, from: actorDataJson)
        popularPeopleList = actorResponseData.results!

    }
    
    func getPopularPeople(page: Int, completion: @escaping (MDBResult<[ActorInfoResponse]>) -> Void) {
        completion(.success([ActorInfoResponse]()))
    }
    
    func getPopularPeople(page: Int) -> Observable<[ActorInfoResponse]> {
        return Observable.just(popularPeopleList)
    }
    
    func getActorGallery(id: Int, completion: @escaping (MDBResult<ActorProfileInfo>) -> Void) {
        fatalError("TODO")
    }
    
    func getActorDetails(id: Int, completion: @escaping (MDBResult<ActorDetailInfo>) -> Void) {
        fatalError("TODO")
    }
    
    func getTVCredits(id: Int, completion: @escaping (MDBResult<ActorTVCredits>) -> Void) {
        fatalError("TODO")
    }
    
    
}
