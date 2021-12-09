//
//  MovieViewModelTest.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import XCTest
@testable import Starter
import RxSwift
import RxCocoa
import RxTest

class MovieViewModelTest: XCTestCase {
    
    var movieModel: MockRxMovieModel!
    var actorModel: MockActorModel!
    
    var viewModel: MovieViewModel!
    
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        movieModel = MockRxMovieModel()
        actorModel = MockActorModel()
        
        viewModel = MovieViewModel(movieModel: movieModel, actorModel: actorModel)
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetchAllDataHomeItemList_allDataExist_returnsAllItems() throws {
        
        let responseExpectation = expectation(description: "wait for response")
        
        viewModel.fetchAllData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertGreaterThan(self.viewModel.homeItemList.value.count, 1)
            responseExpectation.fulfill()
        }

        wait(for: [responseExpectation], timeout: 2)
        
    }
    
    func test_fetchAllDataHomeItemList_allDataIsEmpty_returnsMovieShowTimeSectionItemOnly() throws {
        //Prepare Data
        movieModel.movieData = []
        movieModel.genreData = []
        
        actorModel.popularPeopleList = []
        
        let responseExpectation = expectation(description: "wait for response")
        
        viewModel.fetchAllData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.homeItemList.value.count, 1)
            responseExpectation.fulfill()
        }
        
        wait(for: [responseExpectation], timeout: 2)
    }
    
    func test_fetchAllDataHomeItemList_upcomingMoviesIsEmpty_returnsWithoutUpcomingMovies() throws {
        //Prepare Data
        movieModel.upcomingMoviesAreEmpty = true
        
        let responseExpectation = expectation(description: "wait for response")
        
        viewModel.fetchAllData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.homeItemList.value.count, 6)
            responseExpectation.fulfill()
        }
        
        wait(for: [responseExpectation], timeout: 2)
    }
    
}
