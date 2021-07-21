// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let upcomingMovieList = try? newJSONDecoder().decode(UpcomingMovieList.self, from: jsonData)

import Foundation

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
    public let posterPath, releaseDate, title: String?
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
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    public init(adult: Bool?, backdropPath: String?, genreIDS: [Int]?, id: Int?, originalLanguage: String?,  originalName: String?, originalTitle: String?, overview: String?, popularity: Double?, posterPath: String?, releaseDate: String?, title: String?, video: Bool?, voteAverage: Double?, voteCount: Int?) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
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
}

public enum OriginalLanguage: String, Codable {
    case en = "en"
    case ja = "ja"
    case es = "es"
}
