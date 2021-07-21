// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorDetailInfo = try? newJSONDecoder().decode(ActorDetailInfo.self, from: jsonData)

import Foundation

// MARK: - ActorDetailInfo
public struct ActorDetailInfo: Codable {
    public let adult: Bool?
    public let alsoKnownAs: [String]?
    public let biography, birthday, deathday: String?
    public let gender: Int?
    public let homepage: String?
    public let id: Int?
    public let imdbID, knownForDepartment, name, placeOfBirth: String?
    public let popularity: Double?
    public let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }

    public init(adult: Bool?, alsoKnownAs: [String]?, biography: String?, birthday: String?, deathday: String?, gender: Int?, homepage: String?, id: Int?, imdbID: String?, knownForDepartment: String?, name: String?, placeOfBirth: String?, popularity: Double?, profilePath: String?) {
        self.adult = adult
        self.alsoKnownAs = alsoKnownAs
        self.biography = biography
        self.birthday = birthday
        self.deathday = deathday
        self.gender = gender
        self.homepage = homepage
        self.id = id
        self.imdbID = imdbID
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.placeOfBirth = placeOfBirth
        self.popularity = popularity
        self.profilePath = profilePath
    }
}
