//
//  NetworkClientTest.swift
//  NetworkClientTest
//
//  Created by Thet Htun on 5/9/20.
//  Copyright © 2020 padc. All rights reserved.
//

import XCTest
@testable import Starter
import Mocker
import Alamofire

class NetworkClientTest: XCTestCase {
    
    let networkClient = MovieDBNetworkAgent.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //Init Mock
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        
        //Setting up dependency
        let sessionManager = Session(configuration: configuration)
        networkClient.sessionManager = sessionManager
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - Search Movie Result
    func test_searchMovie_successWithValidResponse_returnsCorrectData() throws {
        //Prepare mock data
        let query: String = "game"
        let page: Int = 1
        let apiEndpoint = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(query)&page=\(page)&api_key=\(AppConstants.apiKey)")!
        
        let searchMovieExpectation = expectation(description: "wait for search movie")
        
        //Convert object into JSON
        //        let mockedData = try! JSONEncoder().encode(expectedResponse)
        
        //Load Data from json file
        let mockedDataFromJSON = try! Data(contentsOf: MovieMockData.SearchMovieResult.searchResultJSONUrl)
        
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 200,
            data: [.get: mockedDataFromJSON])
        
        mock.register()
        
        networkClient.searchMovieByKeyword(
            query: query, page: "\(page)") { (result) in
            
            switch result {
            case .success(let response):
                XCTAssertEqual(response.page, 1)
                XCTAssertGreaterThan(response.results!.count, 0)
            case .failure(let error):
                XCTFail("Shouldn't fail with \(error)")
            }
            
            searchMovieExpectation.fulfill()
        }
        
        wait(for: [searchMovieExpectation], timeout: 5)
        
        
    }
    
    func test_searchMovie_failedWithCorruptJson_returnsCustomErrorMessage() throws {
        //Prepare mock data
        let query: String = "game"
        let page: String = "1"
        let apiEndpoint = MDBEndpoint.searchMovie(page, query).url
        
        //Load Data from json file
        let mockedDataFromJSON = try! Data(contentsOf: MovieMockData.corruptResponseURL)
        
        //For asynchronous event
        let searchMovieExpectation = expectation(description: "wait for search movie")
        
        //Register mock
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 200,
            data: [.get: mockedDataFromJSON])
        mock.register()
        
        networkClient.searchMovieByKeyword(
            query: query, page: page) { (result) in
            
            switch result {
            case .success(_):
                XCTFail("Shouldn't succeed")
            case .failure(let error):
                print("\(#function) : error")
                XCTAssertGreaterThan(error.count, 0)
            }
            
            searchMovieExpectation.fulfill()
        }
        
        wait(for: [searchMovieExpectation], timeout: 5)
    }

    func test_searchMovie_withoutAPIKey_returnsErrorMessage() throws {
        //Prepare mock data
        let query: String = "game"
        let page: String = "1"
        let apiEndpoint = MDBEndpoint.searchMovie(page, query).url
        
        //Load Data from json file
        let mockedDataFromJSON = try! Data(contentsOf: MovieMockData.SearchMovieResult.invalidAPIKeyResponseJSONUrL)
        
        //For asynchronous event
        let searchMovieExpectation = expectation(description: "wait for search movie")
        
        //Register mock
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 401,
            data: [.get: mockedDataFromJSON])
        mock.register()
        
        networkClient.searchMovieByKeyword(
            query: query, page: page) { (result) in
            
            switch result {
            case .success(_):
                XCTFail("Shouldn't succeed")
            case .failure(let error):
                XCTAssertEqual(error, "Invalid API key: You must be granted a valid key.")
                
            }
            
            searchMovieExpectation.fulfill()
        }
        
        wait(for: [searchMovieExpectation], timeout: 5)
        
    }
    
    func test_searchMovie_withoutQuery_returnsErrorMessage() throws {
        
    }
        
    /**
     What would happen if the following issues arises?
     
     - Incorrect HTTP method
     - 4.x.x
     - 500 Server Error
     */
    
    
    /**
     searchMovieByKeyword(_:) // This done! :D
     
     //These remains to be tested.
     getMovieTrailers(_:)
     getSimilarMovies(_:)
     getMovieCreditById(_:)
     getMovieDetailById(_:)
     
     getTopRatedMovieList(_:)
     getPopularMovieList(_:)
     getUpcomingMovieList(_:)
     getGenreList(_:)
     getPopularPeople(_:)

     getPopularSeriesList(_:)
     getSerieDetailById(_:)

     getActorGallery(_:)
     getActorDetails(_:)
     getTVCredits(_:)
     */
}
