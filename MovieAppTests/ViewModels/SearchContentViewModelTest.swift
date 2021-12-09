//
//  SearchContentViewModelTest.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import XCTest
@testable import Starter
import RxSwift

class SearchContentViewModelTest: XCTestCase {

    var viewModel: RxSearchContentVCViewModel!
    var networkAgent: MockRxNetworkAgent!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        networkAgent = MockRxNetworkAgent()
        
        viewModel = RxSearchContentVCViewModel(networkAgent: networkAgent)
        
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        networkAgent = nil
        disposeBag = nil
    }

    func test_viewModelInitState_withInitialization_returnsCorrectState() throws {
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.itemSpacing, 10)
        XCTAssertEqual(viewModel.numberOfItemsPerRow, 3)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPage, 1)
    }
    
    func test_handlePagination_withIndexPathAndSearchText_currentPageShouldIncrement() throws {
        let indexPath = IndexPath(row: 0, section: 0)
        
        //Prepare Data
        viewModel.searchResultItems.onNext([MovieResult.dummy()])
        viewModel.currentPage = 1
        viewModel.totalPage = 2
        
        //Trigger target method
        viewModel.handlePagination(indexPath: indexPath, searchText: "abc")
        
        //Assertion
        XCTAssertEqual(viewModel.currentPage, 2)
    }
    
    func test_handleSearchInputText_withTextEmpty_dataShouldReset() throws {
        viewModel.handleSearchInputText(text: "")
        
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertEqual(viewModel.totalPage, 1)
        
        let waitExpectation = expectation(description: "wait for response")
        viewModel.searchResultItems
            .subscribe(onNext: { data in
                XCTAssertEqual(data.count, 0)
                waitExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [waitExpectation], timeout: 5)
    }
    
    func test_searchMovies_withSampleData_shouldItems() throws {
        
        viewModel.searchMovies(keyword: "test", page: 1)
        
        let waitExpectation = expectation(description: "wait for response")

        viewModel.searchResultItems
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                XCTAssertEqual(self.viewModel.totalPage, 74)
                XCTAssertGreaterThan(data.count, 0)
                waitExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [waitExpectation], timeout: 5)
    }
    
}
