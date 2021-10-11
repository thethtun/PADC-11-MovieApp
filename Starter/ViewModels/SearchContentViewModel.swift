//
//  SearchContentViewModel.swift
//  Starter
//
//  Created by Thet Htun on 10/12/21.
//

import Foundation
import RxSwift
import RxCocoa

class RxSearchContentVCViewModel {
    
    let itemSpacing : CGFloat = 10
    let numberOfItemsPerRow = 3
    var currentPage : Int = 1
    var totalPage : Int = 1
    
    let searchResultItems = BehaviorSubject<[MovieResult]>(value: [])
    
    
    let disposeBag = DisposeBag()
    
    let networkAgent : RxNetworkAgentProtocol = RxNetworkAgent.shared
    
    init() { }
    
    func handlePagination(indexPath: IndexPath, searchText: String) {
        let totalItems = try! self.searchResultItems.value().count
        let isAtLastRow = indexPath.row == totalItems - 1
        let hasMorePages = self.currentPage < self.totalPage
        if (isAtLastRow && hasMorePages){
            self.currentPage += 1
            self.searchMovies(keyword: searchText, page: self.currentPage)
        }
    }
    
    func handleSearchInputText(text: String) {
        if text.isEmpty {
            self.currentPage = 1
            self.totalPage = 1
            self.searchResultItems.onNext([])
        } else {
            self.searchMovies(keyword: text, page: self.currentPage)
        }
    }
    
    func searchMovies(keyword : String, page : Int) {
        networkAgent.searchMovies(query: keyword, page: "\(page)")
            .do(onNext: { item in
                self.totalPage = item.totalPages ?? 1
            })
            .compactMap { $0.results }
            .subscribe(onNext: { item in
                if self.currentPage == 1 {
                    self.searchResultItems.onNext(item)
                } else {
                    self.searchResultItems.onNext(try! self.searchResultItems.value() + item)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    
}
