//
//  ActorListReponse.swift
//  Starter
//
//  Created by Thet Htun on 5/25/21.
//

import Foundation

public struct ActorListResponse : Codable {
    public let dates: Dates?
    public let page: Int?
    public let results: [ActorInfoResponse]?
    public let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


public struct ActorInfoResponse : Codable {
    let adult: Bool?
    let gender : Int?
    let id : Int?
    let knownFor : [MovieResult]?
    let knwonForDepartment: String?
    let name : String?
    let popularity : Double?
    let profilePath : String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownFor = "known_for"
        case knwonForDepartment = "known_for_department"
        case name
        case popularity
        case profilePath = "profile_path"
    }
}
