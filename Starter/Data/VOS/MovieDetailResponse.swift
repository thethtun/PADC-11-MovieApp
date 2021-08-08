
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDetailResponse = try? newJSONDecoder().decode(MovieDetailResponse.self, from: jsonData)

import Foundation
import CoreData
import RealmSwift

// MARK: - MovieDetailResponse
public struct MovieDetailResponse: Codable {
    public let adult: Bool?
    public let backdropPath: String?
    public let belongsToCollection: BelongsToCollection?
    public let budget: Int?
    public let genres: [MovieGenre]?
    public let homepage: String?
    public let id: Int?
    public let imdbID, originalLanguage, originalTitle, overview: String?
    public let popularity: Double?
    public let posterPath: String?
    public let productionCompanies: [ProductionCompany]?
    public let productionCountries: [ProductionCountry]?
    public let releaseDate: String?
    public let revenue, runtime: Int?
    public let spokenLanguages: [SpokenLanguage]?
    public let status, tagline, title: String?
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?
    public let name : String?
    public let lastAirDate : String?
    public let firstAirDate : String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case name
        case lastAirDate = "last_air_date"
        case firstAirDate = "first_air_date"
    }
    
    func toMovieObject() -> MovieObject {
        let object = MovieObject()
        object.id = self.id!
        object.adult = self.adult
        object.backdropPath = self.backdropPath
        object.genreIDS = self.genres?.map { $0.name }.joined(separator: ",")
        object.originalLanguage = self.originalLanguage
        object.originalTitle = self.originalTitle
        object.originalName  = self.originalTitle
        object.overview = self.overview
        object.popularity = self.popularity
        object.posterPath = self.posterPath
        object.releaseDate = self.releaseDate
        object.firstAirDate = self.firstAirDate
        object.title = self.title
        object.video = self.video
        object.voteAverage = self.voteAverage
        object.voteCount = self.voteCount
        self.genres?.map { $0.toGenreObject() }.appendItems(to: object.genres)
        object.belongsToCollection = self.belongsToCollection?.toBelongsToCollectionObject()
        self.spokenLanguages?.map { $0.toSpokenLanguageObject() }.appendItems(to: object.spokenLanguages)
        self.productionCompanies?.map { $0.toProductionCompanyObject() }.appendItems(to: object.productionCompanies)
        self.productionCountries?.map { $0.toProductionCountryObject() }.appendItems(to: object.productionCountries)
        return object
    }

    func toMovieEntity(context: NSManagedObjectContext) -> MovieEntity {
        let entity = MovieEntity(context: context)
        entity.adult = self.adult ?? false
        entity.backdropPath = self.backdropPath
        
        entity.belongsToCollection = self.belongsToCollection?.toBelongsToCollectionEntity(context: context)
        
        entity.budget = Int64(self.budget ?? 0)

        self.genres?.forEach {
            entity.addToGenres($0.toGenreEntity(context: context))
        }
        entity.homePage = self.homepage
        entity.id = Int32(self.id ?? 0)
        entity.imdbID = self.imdbID
        entity.originalLanguage = self.originalLanguage
        entity.originalTitle = self.originalTitle
        entity.overview = self.overview
        entity.popularity = self.popularity ?? 0
        entity.posterPath = self.posterPath
        self.productionCompanies?.forEach {
            entity.addToProductionCompanies($0.toProductionCompanyEntity(context: context))
        }

        self.productionCountries?.forEach {
            entity.addToProductionCountries($0.toProductionCountryEntity(context: context))
        }

        entity.releaseDate = self.releaseDate
        entity.revenu = Int64(self.revenue ?? 0)
        entity.runTime = Int64(self.runtime ?? 0)
        
        self.spokenLanguages?.forEach {
            entity.addToSpokenLanguage($0.toSpokenLanguageEntity(context: context))
        }

        entity.status = self.status
        entity.tagline = self.tagline
        entity.title = self.title
        entity.video = self.video ?? false
        entity.voteAverage = self.voteAverage ?? 0
        entity.voteCount = Int64(self.voteCount ?? 0)
        entity.originalName = self.name
        entity.lastAirDate = self.lastAirDate
        entity.firstAirDate = self.firstAirDate
        
        return entity
    }
}


