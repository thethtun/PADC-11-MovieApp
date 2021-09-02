//
//  SearchContentViewController.swift
//  Starter
//
//  Created by Thet Htun on 6/28/21.
//

import UIKit
import RxCocoa
import RxSwift

class RxSearchContentVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var collectionViewResult : UICollectionView!
    private let searchBar = UISearchBar()
    
    private let itemSpacing : CGFloat = 10
    private let numberOfItemsPerRow = 3
    private var currentPage : Int = 1
    private var totalPage : Int = 1
    
    //MARK: - 3
    let searchResultItems : BehaviorSubject<[MovieResult]> = BehaviorSubject(value: [])
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        initObservers()
    }
    // MARK: - Init View
    private func initView() {
        searchBar.placeholder = "Search..."
        searchBar.searchTextField.textColor = .white
        
        navigationItem.titleView = searchBar
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action:#selector(onClickDismiss))
        navigationItem.leftBarButtonItem = backButton
        
        setupCollectionView()
    }
 
    func setupCollectionView() {
//        collectionViewResult.dataSource = self
        collectionViewResult.delegate = self
        collectionViewResult.showsHorizontalScrollIndicator = false
        collectionViewResult.showsVerticalScrollIndicator = false
        collectionViewResult.contentInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        if let layout = collectionViewResult.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        
        collectionViewResult.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
    }
   
    private func initObservers() {
        addSearchBarObserver()
        addCollectionViewBindingObserver()
        addItemSelectedObserver()
        addPaginationObserver()
    }
    
    @objc func onClickDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - API
    private func rxMovieSearch(keyword : String, page : Int) {
        //MARK: - 2
        RxNetworkAgent.shared.searchMovies(query: keyword, page: "\(page)")
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

//MARK: - Observers
extension RxSearchContentVC {
    //MARK: - 1
    private func addSearchBarObserver() {
        // Search Text Field event listener
        searchBar.rx.text.orEmpty
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .do(onNext: { print($0)})
            .subscribe(onNext: { value in
                if value.isEmpty {
                    self.currentPage = 1
                    self.totalPage = 1
                    self.searchResultItems.onNext([])
                } else {
                    self.rxMovieSearch(keyword: value, page: self.currentPage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - 4
    private func addCollectionViewBindingObserver() {
        // Bind Data to collection view cell
        searchResultItems
            .bind(to: collectionViewResult.rx.items(
                    cellIdentifier: String(describing: PopularFilmCollectionViewCell.self),
                    cellType: PopularFilmCollectionViewCell.self))
            { row, element, cell in
                cell.data = element
            }
            .disposed(by: disposeBag)
    }
    
    private func addItemSelectedObserver() {
        // On Item Selected
        // MARK: - 6
        collectionViewResult.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let items = try! self.searchResultItems.value()
                let item = items[indexPath.row]
                self.navigateToMovieDetailViewController(movieId: item.id!)
            })
            .disposed(by: disposeBag)
    }
    
    private func addPaginationObserver() {
        /// Pagination
        // MARK: - 5
        Observable.combineLatest(
            collectionViewResult.rx.willDisplayCell,
            searchBar.rx.text.orEmpty)
            .subscribe(onNext : { (cellTuple, searchText) in
                let (_, indexPath) = cellTuple
                let totalItems = try! self.searchResultItems.value().count
                let isAtLastRow = indexPath.row == totalItems - 1
                let hasMorePages = self.currentPage < self.totalPage
                if (isAtLastRow && hasMorePages){
                    self.currentPage += 1
                    self.rxMovieSearch(keyword: searchText, page: self.currentPage)
                }
            })
            .disposed(by: disposeBag)
    }
    
}



//MARK: - UICollectionViewDelegateFlowLayout
extension RxSearchContentVC:UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalColumnSpacing : CGFloat = (itemSpacing * CGFloat(numberOfItemsPerRow - 1)) + collectionView.contentInset.left + collectionViewResult.contentInset.right
        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(numberOfItemsPerRow)) - (totalColumnSpacing / CGFloat(numberOfItemsPerRow))
        let itemHeight : CGFloat = (itemWidth * 1.5) + 80 /* For Text & Rating */
        return CGSize(width: itemWidth, height:  itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }

}
