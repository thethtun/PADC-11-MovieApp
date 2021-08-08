// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorDetailInfo = try? newJSONDecoder().decode(ActorDetailInfo.self, from: jsonData)

import Foundation
import CoreData

// MARK: - ActorDetailInfo
public struct ActorDetailInfo: Codable {
    public let adult: Bool?
    public let alsoKnownAs: [String]?
    public let biography, birthday, deathday: String?
    public let gender: Int?
    public let homepage: String?
    public let id: Int?
    public let knownFor : [MovieResult]?
    public var imdbID, knownForDepartment, name, placeOfBirth: String?
    public let popularity: Double?
    public let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case knownFor
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
    
    func toActorObject() -> ActorObject {
        let object = ActorObject()
        object.adult = self.adult ?? false
        object.alsoKnownAs = self.alsoKnownAs?.map { String($0) }.joined(separator: ",") ?? ""
        object.biography = self.biography
        object.birthday = self.birthday
        object.deathday = self.deathday
        object.gender = self.gender ?? 0
        object.id = self.id!
        object.imdbID = self.imdbID
        object.name = self.name
        object.placeOfBirth = self.placeOfBirth
        object.popularity = self.popularity ?? 0
        object.profilePath = self.profilePath
        return object
    }
    
    func toActorEntity(context: NSManagedObjectContext) -> ActorEntity {
        let entity = ActorEntity(context: context)
        entity.adult = self.adult ?? false
        entity.alsoKnownAs = self.alsoKnownAs?.map { String($0) }.joined(separator: ",")
        entity.biography = self.biography
        entity.birthday = self.birthday
        entity.deathday = self.deathday
        entity.gender = Int32(self.gender ?? 0)
        entity.id = Int32(self.id!)
        entity.imdbID = self.imdbID
        entity.homePage = self.homepage
        entity.name = self.name
        entity.placeOfBirth = self.placeOfBirth
        entity.popularity = self.popularity ?? 0
        entity.profilePath = self.profilePath
        return entity
    }
    
}
