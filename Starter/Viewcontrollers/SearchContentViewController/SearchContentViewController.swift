//
//  SearchContentViewController2.swift
//  Starter
//
//  Created by Thet Htun on 6/28/21.
//

import UIKit
import RxCocoa
import RxSwift

class SearchContentViewController2: UIViewController, UITextFieldDelegate {
    
    weak var collectionViewResult : UICollectionView!
//    @IBOutlet weak var textFieldSearch : UITextField!
    private let searchBar = UISearchBar()
    
    private var searchedResult : [MovieResult] = []

    
    private let itemSpacing : CGFloat = 10
    private let numberOfItemsPerRow = 3
    private var currentPage : Int = 1
    private var totalPage : Int = 1
    
    private let networkAgent = MovieDBNetworkAgent.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
    }
    
    private func initView() {
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        searchBar.searchTextField.textColor = .white
        
        navigationItem.titleView = searchBar
        
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionViewResult.dataSource = self
        collectionViewResult.delegate = self
        collectionViewResult.showsHorizontalScrollIndicator = false
        collectionViewResult.showsVerticalScrollIndicator = false
        collectionViewResult.contentInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        if let layout = collectionViewResult.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        
        collectionViewResult.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
    }
    
    // MARK: TODO - 1 - Reactive UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        if let data = textField.text {
            self.currentPage = 1
            self.totalPage = 1
            self.searchedResult.removeAll()
            searchContent(keyword: data, page: currentPage)
        }
        return false
    }
    
    @IBAction func onClickDismiss(_ sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TODO - 2 - Observable Network Response
    func searchContent(keyword : String, page : Int) {
        networkAgent.searchMovieByKeyword(query: keyword, page: "\(page)") { (result) in
            switch result {
            case .success(let data):
                self.totalPage = data.totalPages ?? 1
                self.searchedResult.append(contentsOf: data.results ?? [MovieResult]())
                self.collectionViewResult.reloadData()
            case .failure(let message):
                print(message.debugDescription)
            }
        }
    }
    
}



//MARK: - UICollectionViewDataSource
extension SearchContentViewController2: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedResult.count
    }

    //MARK: - TODO - 3 - Refactor Data Binding
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else { return UICollectionViewCell() }
        cell.data = searchedResult[indexPath.row]
        //MARK: - TODO - 5 - Item selection
        cell.onTapItem = { id, _ in
            self.navigateToMovieDetailViewController(movieId: id)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchContentViewController2:UICollectionViewDelegateFlowLayout {
    
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
    
    //MARK: - TODO - 4 - Refactor Pagination using RxCocoa
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == self.searchedResult.count - 1
        let hasMorePages = self.currentPage < self.totalPage
        if (isAtLastRow && hasMorePages){
            currentPage = currentPage + 1
            searchContent(keyword: searchBar.text ?? "", page: currentPage)
        }
    }
    
}

extension SearchContentViewController2: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        if let data = searchBar.text {
            self.currentPage = 1
            self.totalPage = 1
            self.searchedResult.removeAll()
            searchContent(keyword: data, page: currentPage)
        }
    }
}
