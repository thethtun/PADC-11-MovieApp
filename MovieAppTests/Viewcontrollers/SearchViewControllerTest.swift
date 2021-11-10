//
//  SearchViewControllerTest.swift
//  MovieAppTests
//
//  Created by Thet Htun on 11/5/21.
//

import XCTest
@testable import Starter

class SearchViewControllerTest: XCTestCase {

    var viewModel: MockRxSearchViewModel!
    var viewController: RxSearchContentVC!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = MockRxSearchViewModel()
        
        //Setup ViewController
        viewController = RxSearchContentVC(viewModel: viewModel)
        _ = viewController.view
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewController = nil
    }
    
    func test_viewControllerInit_withInitialization_shouldSucceed() throws {
        XCTAssertNotNil(viewController.collectionViewResult)
        
        //Test Search Bar Init State
        XCTAssertEqual(viewController.searchBar.placeholder, "Search...")
        
        //Test CollectionView Init State
        XCTAssertEqual(viewController.collectionViewResult.contentInset, UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16))
        XCTAssertEqual(viewController.collectionViewResult.showsHorizontalScrollIndicator, false)
        XCTAssertEqual(viewController.collectionViewResult.showsVerticalScrollIndicator, false)
        XCTAssertNil(viewController.collectionViewResult.cellForItem(at: IndexPath(row: 0, section: 0)))
        
    }
    
    func test_viewController_searchInput_shouldCallViewModleSearchMethod() throws {
        let sampleSearchtext: String = "this is a name"
        
        viewController.searchBar.text = sampleSearchtext
       
        let sutSearchBar = viewController.searchBar
        sutSearchBar.delegate?.searchBar?(sutSearchBar, textDidChange: sampleSearchtext)
       
        viewModel.expectationForSearchInputText = expectation(description: "search input expectation")
        
        self.waitForExpectations(timeout: 5) { error in
            if error != nil {
                XCTFail()
            }
            XCTAssertTrue(self.viewModel.handleSearchInputTextCalled)
            XCTAssertEqual(self.viewModel.searchInputText, sampleSearchtext)
        }
    }
    
    func test_viewController_searchMovies_shouldShouldCellWithCorrectData() throws {
        let movieDataJson = try! Data(contentsOf: MovieMockData.SearchMovieResult.searchResultJSONUrl)
        let movieResponseData = try! JSONDecoder().decode(MovieListResponse.self, from: movieDataJson)
        viewModel.searchResultItems.onNext(movieResponseData.results!)
       
        let waitExpectation = expectation(description: "fuck async")
        
        executeRunLoop()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let firstIndex: IndexPath = IndexPath(row: 0, section: 0)
            let cell = self.viewController.collectionViewResult.cellForItem(at: firstIndex)!
            let popularFilmCell = cell as! PopularFilmCollectionViewCell
            XCTAssertNotNil(popularFilmCell.data)
            
            waitExpectation.fulfill()
        }
        
        wait(for: [waitExpectation], timeout: 6)
        
//        let sutSearchBar = viewController.searchBar
//        sutSearchBar.delegate?.searchBar?(sutSearchBar, textDidChange: MockRxSearchViewModel.validMovieSearchKeyword)
//
//        viewModel.expectationForSearchMovieResult = expectation(description: "search movie result expectation")
//
//        self.waitForExpectations(timeout: 5) { error in
//            if error != nil {
//                XCTFail()
//            }
//            sleep(1)
//            let firstIndex: IndexPath = IndexPath(row: 0, section: 0)
//            let cell = try! XCTUnwrap(self.viewController.collectionViewResult.cellForItem(at: firstIndex))
//            let popularFilmCell = cell as! PopularFilmCollectionViewCell
//            XCTAssertNotNil(popularFilmCell.data)
//
//            //XCTAssertTrue(self.viewModel.handleSearchInputTextCalled)
//            //XCTAssertEqual(self.viewModel.searchInputText, sampleSearchtext)
//        }
//
    }
    
    func executeRunLoop() {
        RunLoop.current.run(until: Date())
    }
}
