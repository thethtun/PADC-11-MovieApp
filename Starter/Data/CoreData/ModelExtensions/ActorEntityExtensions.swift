//
//  ActorEntityExtensions.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

extension ActorEntity {
    
    static func toActorInfoResponse(entity : ActorEntity) -> ActorInfoResponse {
        ActorInfoResponse(
            adult:entity.adult,
            gender: Int(entity.gender),
            id: Int(entity.id),
            knownFor: (entity.credits as? Set<MovieEntity>)?.map { MovieEntity.toMovieResult(entity: $0) } ,
            knwonForDepartment: "",
            name:entity.name,
            popularity:entity.popularity,
            profilePath:entity.profilePath)
    }
    
    static func toMovieCast(entity : ActorEntity) -> MovieCast {
        MovieCast(
            adult: entity.adult,
            gender: Int(entity.gender),
            id: Int(entity.id),
            knownForDepartment: entity.knownForDepartment,
            name: entity.name,
            originalName: entity.name,
            popularity: entity.popularity,
            profilePath: entity.profilePath,
            castID: nil,
            character: nil,
            creditID: nil,
            order: nil,
            department: nil,
            job: nil)
    }
    
    static func toActorInfoDetail(entity : ActorEntity) -> ActorDetailInfo {
        ActorDetailInfo(
            adult: entity.adult,
            alsoKnownAs: entity.alsoKnownAs?.components(separatedBy: ",").compactMap { $0.trimmingCharacters(in: .whitespaces) },
            biography: entity.biography,
            birthday: entity.birthday,
            deathday: entity.deathday,
            gender: Int(entity.gender),
            homepage: entity.homePage,
            id: Int(entity.id),
            knownFor: (entity.credits as? Set<MovieEntity>)?.map { MovieEntity.toMovieResult(entity: $0) },
            imdbID: entity.imdbID,
            knownForDepartment: entity.knownForDepartment,
            name: entity.name,
            placeOfBirth: entity.placeOfBirth,
            popularity: entity.popularity,
            profilePath: entity.profilePath)
    }
}
