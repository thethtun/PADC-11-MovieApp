// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let upcomingMovieList = try? newJSONDecoder().decode(UpcomingMovieList.self, from: jsonData)

import Foundation
import CoreData

// MARK: - UpcomingMovieList
public struct MovieListResponse: Codable {
    public let dates: Dates?
    public let page: Int?
    public let results: [MovieResult]?
    public let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    public init(dates: Dates?, page: Int?, results: [MovieResult]?, totalPages: Int?, totalResults: Int?) {
        self.dates = dates
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    static func empty() -> MovieListResponse {
        MovieListResponse(dates: nil, page: nil, results: nil, totalPages: nil, totalResults: nil)
    }
}

// MARK: - Dates
public struct Dates: Codable {
    public let maximum, minimum: String?

    public init(maximum: String?, minimum: String?) {
        self.maximum = maximum
        self.minimum = minimum
    }
}

// MARK: - Result
public struct MovieResult: Codable, Hashable {
    public let adult: Bool?
    public let backdropPath: String?
    public let genreIDS: [Int]?
    public let id: Int?
    public let originalLanguage: String?
    public let originalTitle, originalName, overview: String?
    public let popularity: Double?
    public let posterPath, releaseDate, firstAirDate, title: String?
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func getVideoType() -> VideoType {
        /*
         Both movie list & series list return same object schema.
         API doesn't specify types. But there are a few differences
         
         if series data, title is in original_name
         if movie data, title is in origintal_title
         */
        return self.originalName != nil ? .serie : .movie
    }
    
    func toMovieObject(groupType : BelongsToTypeObject) -> MovieObject {
        
        let object = MovieObject()
        object.id = id!
        object.adult = adult ?? false
        object.backdropPath = backdropPath
        object.genreIDS = genreIDS?.map { String($0) }.joined(separator: ",") ?? ""
        object.originalLanguage = originalLanguage
        object.originalName = originalName
        object.originalTitle = originalTitle
        object.overview = overview
        object.popularity = popularity ?? 0
        object.posterPath = posterPath
        object.releaseDate = releaseDate ?? firstAirDate ?? ""
        object.title = title
        object.video = video ?? false
        object.voteAverage = voteAverage ?? 0
        object.voteCount = voteCount
        object.belongsToType.append(groupType)
        return object
        
    }
    
    @discardableResult
    func toMovieEntity(
        context : NSManagedObjectContext,
        groupType : BelongsToTypeEntity) -> MovieEntity {
        
        let entity = MovieEntity(context: context)
        entity.id = Int32(id!)
        entity.adult = adult ?? false
        entity.backdropPath = backdropPath
        entity.genreIDs = genreIDS?.map { String($0) }.joined(separator: ",")
        entity.originalLanguage = originalLanguage
        entity.originalName = originalName
        entity.originalTitle = originalTitle
        entity.overview = overview
        entity.popularity = popularity ?? 0
        entity.posterPath = posterPath
        entity.releaseDate = releaseDate ?? firstAirDate ?? ""
        entity.title = title
        entity.video = video ?? false
        entity.voteAverage = voteAverage ?? 0
        entity.voteCount = Int64(voteCount ?? 0)
        entity.addToBelongsToType(groupType)
        
        return entity
    }
}

public enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case es = "es"
}
