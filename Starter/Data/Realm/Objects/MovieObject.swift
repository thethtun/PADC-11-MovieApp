//
//  MovieObjects.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

class MovieObject : Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true)
    var id: Int
    
    @Persisted
    var adult: Bool?
    
    @Persisted
    var backdropPath: String?
    
    @Persisted
    var genreIDS: String?
    
    @Persisted
    var originalLanguage: String?
    
    @Persisted
    var originalTitle: String?
    
    @Persisted
    var originalName : String?
    
    @Persisted
    var overview: String?
    
    @Persisted
    var popularity: Double?
    
    @Persisted
    var posterPath: String?
    
    @Persisted
    var releaseDate: String?
    
    @Persisted
    var firstAirDate: String?
    
    @Persisted
    var title: String?
    
    @Persisted
    var video: Bool?
    
    @Persisted
    var voteAverage: Double?
    
    @Persisted
    var voteCount: Int?
    
    @Persisted
    var revenu : Int?
    
    @Persisted
    var runTime: Int?

    @Persisted
    var status : String?
    
    @Persisted
    var tagline : String?
    
    @Persisted
    var lastAirDate : String
    
    @Persisted
    var homePage: String
    
    @Persisted
    var imdbID : Int?

    @Persisted
    var genres: List<GenreObject>
    
    @Persisted
    var actors: List<ActorObject>
    
    @Persisted
    var belongsToCollection: BelongToCollectionObject?
    
    @Persisted
    var belongsToType: List<BelongsToTypeObject>
    
    @Persisted
    var spokenLanguages: List<SpokenLanguageObject>
    
    @Persisted
    var productionCompanies: List<ProductionCompanyObject>
    
    @Persisted
    var productionCountries: List<ProductionCountryObject>
    
    @Persisted
    var similarMovies: List<MovieObject>
    
    func toMovieResult() -> MovieResult {
        return MovieResult(
            adult: adult,
            backdropPath: backdropPath,
            genreIDS: genreIDS?.components(separatedBy: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) },
            id: Int(id),
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            originalName: originalName,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            firstAirDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: Int(voteCount ?? 0))
    }
    
    func toMovieDetailResponse() -> MovieDetailResponse {
        MovieDetailResponse(
            adult: adult,
            backdropPath: backdropPath,
            belongsToCollection: nil,
            budget: 0,
            genres: genres.map { $0.toMovieGenre() },
            homepage: homePage,
            id: Int(id),
            imdbID: "\(imdbID ?? -1)",
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            productionCompanies: productionCompanies.map { $0.toProductionCompany() },
            productionCountries: productionCountries.map { $0.toProductionCountry() },
            releaseDate: releaseDate,
            revenue: Int(revenu ?? 0),
            runtime: Int(runTime ?? 0),
            spokenLanguages: spokenLanguages.map { $0.toSpokenLanguage() },
            status: status,
            tagline: tagline,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: Int(voteCount ?? 0),
            name: originalName,
            lastAirDate: "",
            firstAirDate: firstAirDate)
    }
    
}
