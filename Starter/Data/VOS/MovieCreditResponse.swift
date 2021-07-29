// This file was generated from JSON Schema using quicktype,do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieCreditResponse = try? newJSONDecoder().decode(MovieCreditResponse.self, from: jsonData)

import Foundation

// MARK: - MovieCreditResponse
public struct MovieCreditResponse: Codable {
    public let id: Int?
    public let cast, crew: [MovieCast]?

    public init(id: Int?, cast: [MovieCast]?, crew: [MovieCast]?) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }
}

// MARK: - Cast
public struct MovieCast: Codable {
    public let adult: Bool?
    public let gender, id: Int?
    public let knownForDepartment, name, originalName: String?
    public let popularity: Double?
    public let profilePath: String?
    public let castID: Int?
    public let character, creditID: String?
    public let order: Int?
    public let department, job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    func convertToActorInfoResponse() -> ActorInfoResponse {
        return ActorInfoResponse(
            adult: self.adult,
            gender: self.gender,
            id: self.id,
            knownFor: nil,
            knwonForDepartment: self.knownForDepartment,
            name: self.name,
            popularity: self.popularity,
            profilePath: self.profilePath)
    }
}
