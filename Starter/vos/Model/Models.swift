//
//  Models.swift
//  networking
//
//  Created by Thet Htun on 4/13/21.
//

import Foundation

struct LoginSuccess : Codable {
    let success : Bool?
    let expiresAt : String
    let requestToken : String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct LoginFailed : Codable {
    let success : Bool?
    let statusCode : Int?
    let statusMessage : String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

struct LoginRequest: Codable {
    let username : String
    let password : String
    let requestToken : String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
        case requestToken = "request_token"
    }
}

struct RequestTokenResponse: Codable {
    let success: Bool
    let expiresAt : String
    let requestToken : String
    
    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

struct MovieGenreList : Codable {
    let genres : [MovieGenre]
}

public struct MovieGenre : Codable {
    public let id : Int
    public let name : String
    
    enum CodingKeys : String, CodingKey {
        case id
        case name 
    }
    
    func convertToGenreVO() -> GenreVO {
        let vo = GenreVO(id: id, name: name, isSelected: false)
        return vo
    }
}


var movieGenres = [MovieGenre]()
