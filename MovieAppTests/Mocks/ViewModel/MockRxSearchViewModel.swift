//
//  MockRxSearchViewModel.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import Foundation
@testable import Starter
import RxSwift
import XCTest

class MockRxSearchViewModel: RxSearchContentVCViewModelProtocol {
    
    let itemSpacing : CGFloat = 10
    let numberOfItemsPerRow: CGFloat = 3
    var currentPage : Int = 1
    var totalPage : Int = 1
    
    var searchResultItems: BehaviorSubject<[MovieResult]> = BehaviorSubject<[MovieResult]>(value: [])
    
    static let validMovieSearchKeyword: String = "hello"
    
    var handleSearchInputTextCalled: Bool = false
    var searchInputText: String = ""
    
    var handlePaginationCalled: Bool = false

    var expectationForSearchInputText: XCTestExpectation?
    var expectationForSearchMovieResult: XCTestExpectation?
    
    func handlePagination(indexPath: IndexPath, searchText: String) {
        handlePaginationCalled = true
    }
    
    func handleSearchInputText(text: String) {
        handleSearchInputTextCalled = true
        searchInputText = text
        
        expectationForSearchInputText?.fulfill()
        
        searchMovies(keyword: text, page: self.currentPage)
    }
    
    func searchMovies(keyword: String, page: Int) {
        if keyword == MockRxSearchViewModel.validMovieSearchKeyword {
            
            let movieDataJson = try! Data(contentsOf: MovieMockData.SearchMovieResult.searchResultJSONUrl)
            let movieResponseData = try! JSONDecoder().decode(MovieListResponse.self, from: movieDataJson)
            searchResultItems.onNext(movieResponseData.results!)
            
            expectationForSearchMovieResult?.fulfill()
            return
        }
        
        searchResultItems.onNext([MovieResult]())
        expectationForSearchMovieResult?.fulfill()
    }
    
    
}
