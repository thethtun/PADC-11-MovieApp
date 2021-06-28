// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let movieTrailerResponse = try? newJSONDecoder().decode(MovieTrailerResponse.self, from: jsonData)

import Foundation

// MARK: - MovieTrailerResponse
public struct MovieTrailerResponse: Codable {
    public let id: Int?
    public let results: [MovieTrailer]?

    public init(id: Int?, results: [MovieTrailer]?) {
        self.id = id
        self.results = results
    }
}

// MARK: - MovieTrailer
public struct MovieTrailer: Codable {
    public let id: String?
    public let iso639_1: ISO639_1?
    public let iso3166_1: ISO3166_1?
    public let key, name: String?
    public let site: Site?
    public let size: Int?
    public let type: TypeEnum?

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case key, name, site, size, type
    }

    public init(id: String?, iso639_1: ISO639_1?, iso3166_1: ISO3166_1?, key: String?, name: String?, site: Site?, size: Int?, type: TypeEnum?) {
        self.id = id
        self.iso639_1 = iso639_1
        self.iso3166_1 = iso3166_1
        self.key = key
        self.name = name
        self.site = site
        self.size = size
        self.type = type
    }
}

public enum ISO3166_1: String, Codable {
    case us = "US"
}

public enum ISO639_1: String, Codable {
    case en = "en"
}

public enum Site: String, Codable {
    case youTube = "YouTube"
}

public enum TypeEnum: String, Codable {
    case clip = "Clip"
    case featurette = "Featurette"
    case teaser = "Teaser"
    case trailer = "Trailer"
}
