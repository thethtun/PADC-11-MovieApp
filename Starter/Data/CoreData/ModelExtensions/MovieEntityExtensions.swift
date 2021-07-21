//
//  MovieEntity+Extensions.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation
import CoreData

extension MovieEntity {
    static func get(type : MovieGroupType, context: NSManagedObjectContext) -> NSFetchRequest<MovieEntity> {
        let fetchRequest : NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "groupStr", type.rawValue)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "releaseDate", ascending: false),
            NSSortDescriptor(key: "voteCount", ascending: false),
        ]
        return fetchRequest
    }
    
    static func toMovieResult(entity: MovieEntity) -> MovieResult {
        return MovieResult(
            adult: entity.adult,
            backdropPath: entity.backdropPath,
            genreIDS: entity.genreIDs?.components(separatedBy: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) },
            id: Int(entity.id),
            originalLanguage: entity.originalLanguage,
            originalName: entity.originalName,
            originalTitle: entity.originalTitle,
            overview: entity.overview,
            popularity: entity.popularity,
            posterPath: entity.posterPath,
            releaseDate: entity.releaseDate,
            title: entity.title,
            video: entity.video,
            voteAverage: entity.voteAverage,
            voteCount: Int(entity.voteCount))
    }
}
