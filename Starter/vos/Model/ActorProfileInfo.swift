//
//  ActorProfileInfo.swift
//  Starter
//
//  Created by Thet Htun on 6/28/21.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorProfileInfo = try? newJSONDecoder().decode(ActorProfileInfo.self, from: jsonData)

import Foundation

// MARK: - ActorProfileInfo
public struct ActorProfileInfo: Codable {
    public let id: Int?
    public let profiles: [ActorImageDetails]?

    public init(id: Int?, profiles: [ActorImageDetails]?) {
        self.id = id
        self.profiles = profiles
    }
}

// MARK: - Profile
public struct ActorImageDetails: Codable {
    public let aspectRatio: Double?
    public let filePath: String?
    public let height: Int?
    public let iso639_1: String?
    public let voteAverage, voteCount, width: Int?

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case iso639_1 = "iso_639_1"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }

    public init(aspectRatio: Double?, filePath: String?, height: Int?, iso639_1: String?, voteAverage: Int?, voteCount: Int?, width: Int?) {
        self.aspectRatio = aspectRatio
        self.filePath = filePath
        self.height = height
        self.iso639_1 = iso639_1
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.width = width
    }
}

