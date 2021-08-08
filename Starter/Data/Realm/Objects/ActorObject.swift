//
//  ActorObject.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

class ActorObject: Object {
    
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var adult: Bool?
    
    @Persisted
    var alsoKnownAs: String
    
    @Persisted
    var biography : String?
    
    @Persisted
    var birthday: String?
    
    @Persisted
    var deathday: String?
    
    @Persisted
    var gender: Int?
    
    @Persisted
    var homepage: String?
    
    @Persisted
    var knownFor : List<MovieObject>
    
    @Persisted
    var imdbID: String?
    
    @Persisted
    var knownForDepartment: String?
    
    @Persisted
    var name: String?
    
    @Persisted
    var placeOfBirth: String?
    
    @Persisted
    var popularity: Double?
    
    @Persisted
    var profilePath: String?
    
    @Persisted
    var credits : List<MovieObject>
    
    @Persisted
    var insertedAt : Date = Date()
    
     func toActorInfoResponse() -> ActorInfoResponse {
        ActorInfoResponse(
            adult:adult,
            gender: Int(gender ?? 0),
            id: Int(id),
            knownFor: knownFor.map { $0.toMovieResult() },
            knwonForDepartment: knownForDepartment,
            name: name,
            popularity: popularity,
            profilePath: profilePath)
    }
    
     func toMovieCast() -> MovieCast {
        MovieCast(
            adult: adult,
            gender: Int(gender ?? 0),
            id: Int(id),
            knownForDepartment: knownForDepartment,
            name: name,
            originalName: name,
            popularity: popularity,
            profilePath: profilePath,
            castID: nil,
            character: nil,
            creditID: nil,
            order: nil,
            department: nil,
            job: nil)
    }
    
     func toActorInfoDetail() -> ActorDetailInfo {
        ActorDetailInfo(
            adult: adult,
            alsoKnownAs: alsoKnownAs.components(separatedBy: ",").compactMap { $0.trimmingCharacters(in: .whitespaces) },
            biography: biography,
            birthday: birthday,
            deathday: deathday,
            gender: Int(gender ?? 0),
            homepage: homepage ?? "",
            id: Int(id),
            knownFor:  knownFor.map { $0.toMovieResult() },
            imdbID: imdbID,
            knownForDepartment: knownForDepartment,
            name: name,
            placeOfBirth: placeOfBirth,
            popularity: popularity,
            profilePath: profilePath)
    }
}
