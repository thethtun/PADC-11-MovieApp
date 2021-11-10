//
//  RxMovieModelTest.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import XCTest
@testable import Starter
import RxSwift

class RxMovieModelTest: XCTestCase {

    let rxMovieModel = RxMovieModelImpl.shared
    var movieRepository: MovieRepository!
    var contentTypeRepository: ContentTypeRepository!
    var genreRepository: GenreRepository!
    var networkAgent: RxNetworkAgentProtocol!
    
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        movieRepository = MockMovieRepository()
//        contentTypeRepository = MockContentTypeRepository()
//        genreRepository = MockGenreRepository()
//
//
//        rxMovieModel.setUpDependencies(movieRepository: movieRepository, contentTypeRepository: contentTypeRepository, genreRepository: genreRepository, rxNetworkAgent: networkAgent)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getTopRatedMovieList_responseOk_returnsData() {
        
//        let waitExpectation = expectation(description: "Wait for response")
//
//        rxMovieModel.getTopRatedMovieList(page: 1)
//            .subscribe(onNext: { data in
//                XCTAssertGreaterThan(data.count, 0)
//                waitExpectation.fulfill()
//            }, onError: { (_) in
//                XCTFail("Shouldn't fail")
//                waitExpectation.fulfill()
//            })
//            .disposed(by: disposeBag)
//
//        wait(for: [waitExpectation], timeout: 5)
        
    }
}
