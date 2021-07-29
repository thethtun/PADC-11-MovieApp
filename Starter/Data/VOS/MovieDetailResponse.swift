
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieDetailResponse = try? newJSONDecoder().decode(MovieDetailResponse.self, from: jsonData)

import Foundation
import CoreData

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

// MARK: - Belongs To Collection
public struct BelongsToCollection : Codable {
    public let backdropPath : String?
    public let id : Int?
    public let name : String?
    public let posterPath : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
    func toBelongsToCollectionEntity(context: NSManagedObjectContext) -> BelongsToCollectionEntity {
        let entity = BelongsToCollectionEntity(context: context)
        entity.backdropPath = self.backdropPath
        entity.id = Int32(self.id!)
        entity.name = self.name
        entity.posterPath = self.posterPath
        return entity
    }
}

// MARK: - ProductionCompany
public struct ProductionCompany: Codable {
    public let id: Int?
    public let logoPath: String?
    public let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }

    func toProductionCompanyEntity(context: NSManagedObjectContext) -> ProductionCompanyEntity {
        let entity = ProductionCompanyEntity(context: context)
        entity.id = Int32(self.id!)
        entity.logoPath = self.logoPath
        entity.name = self.name
        entity.originCountry = self.originCountry
        return entity
    }
}

// MARK: - ProductionCountry
public struct ProductionCountry: Codable {
    public let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
    
    func toProductionCountryEntity(context: NSManagedObjectContext) -> ProductionCountryEntity {
        let entity = ProductionCountryEntity(context: context)
        entity.iso3166_1 = self.iso3166_1
        entity.name = self.name
        return entity
    }
    
}

// MARK: - SpokenLanguage
public struct SpokenLanguage: Codable {
    public let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }

    func toSpokenLanguageEntity(context: NSManagedObjectContext) -> SpokenLanguageEntity {
        let entity = SpokenLanguageEntity(context: context)
        entity.englishName = self.englishName
        entity.iso639_1 = self.iso639_1
        entity.name = self.name
        return entity
    }
}

// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        
    }
    
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
