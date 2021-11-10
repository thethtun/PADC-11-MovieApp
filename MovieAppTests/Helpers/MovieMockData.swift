//
//  MovieMockData.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/3/21.
//

import Foundation

public final class MovieMockData {
    
    class SearchMovieResult {
        public static let searchResultJSONUrl: URL = Bundle(for: MovieMockData.self).url(forResource: "search_movie_result", withExtension: "json")!
        public static let invalidAPIKeyResponseJSONUrL: URL = Bundle(for: MovieMockData.self).url(forResource: "invalid_api_key_response", withExtension: "json")!
    }
    
    class MovieList {
        public static let topRatedMovieJSONUrl: URL = Bundle(for: MovieMockData.self).url(forResource: "top_rated_movie_list", withExtension: "json")!
    }
    
    class GenreList {
        public static let genreListJSONUrl: URL = Bundle(for: MovieMockData.self).url(forResource: "genre_list", withExtension: "json")!
    }
    
    class ActorList {
        public static let popularPeopleListJSONUrl: URL = Bundle(for: MovieMockData.self).url(forResource: "popular_people_list", withExtension: "json")!
    }
    
    static let corruptResponseURL: URL = Bundle(for: MovieMockData.self).url(forResource: "corrupt_response", withExtension: "html")!
    
}
