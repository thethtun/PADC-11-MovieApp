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

        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            XCTAssertGreaterThan(self.viewModel.homeItemList.value.count, 1)

            responseExpectation.fulfill()
        }

        wait(for: [responseExpectation], timeout: 21)
//
//
//         var homeItemList : [HomeMovieSectionModel] = []
//        viewModel.homeItemList
//            .subscribe (onNext: { (data) in
//                print("item count: \(data.count)")
//                //                homeItemList = data
//                //                XCTAssertGreaterThan(homeItemList.count, 1)
//                //                responseExpectation.fulfill()
//            }).disposed(by: disposeBag)

    }
    
    func test_fetchAllDataHomeItemList_allDataIsEmpty_returnsMovieShowTimeSectionItemOnly() throws {
        
//        let waitExpectation = expectation(description: "wait for rx event")
//
//        let subject = BehaviorSubject<String>(value: "")
//        subject
//            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { data in
//                print(data)
//
//                waitExpectation.fulfill()
//        }).disposed(by: disposeBag)
//
//        subject.onNext("hello")
//        subject.onNext("world")
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            subject.onNext("thethtun")
//        }
//
//        wait(for: [waitExpectation], timeout: 5)
    }
    
    func test_fetchAllDataHomeItemList_upcomingMoviesIsEmpty_returnsWithoutUpcomingMovies() throws {

    }

}
