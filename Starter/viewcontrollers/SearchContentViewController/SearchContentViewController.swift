//
//  SearchContentViewController.swift
//  Starter
//
//  Created by Thet Htun on 6/28/21.
//

import UIKit

class SearchContentViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var collectionViewResult : UICollectionView!
    
    private var searchedResult : [MovieResult] = []
    private let searchBar = UISearchBar()
    
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
        setupCollectionView()
        
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search..."

//        searchBar.searchTextField.attributedText = NSAttributedString.init(
//            string: "",
//            attributes: [
//                NSAttributedString.Key.foregroundColor: UIColor.white,
//            ]
//        )
        searchBar.searchTextField.textColor = UIColor.white
        
        navigationItem.titleView = searchBar
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
    
    func searchContent(keyword : String, page : Int) {
        networkAgent.searchMovieByKeyword(query: keyword, page: "\(page)") { (data) in
            self.totalPage = data.totalPages ?? 1
            self.searchedResult.append(contentsOf: data.results ?? [MovieResult]())
            self.collectionViewResult.reloadData()
        } failure: { (error) in
            print(error.description)
        }
    }
    
    
    
}



//MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension SearchContentViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchedResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else { return UICollectionViewCell() }
        cell.data = searchedResult[indexPath.row]
        cell.onTapItem = { id in
            self.navigateToMovieDetailViewController(movieId: id)
        }
        return cell
        
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchContentViewController:UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == self.searchedResult.count - 1
        let hasMorePages = self.currentPage < self.totalPage
        if (isAtLastRow && hasMorePages){
            currentPage = currentPage + 1
            searchContent(keyword: searchBar.text ?? "", page: currentPage)
        }
    }
    
}

extension SearchContentViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
        self.view.endEditing(true)
//        if let data = searchBar.text {
//            self.currentPage = 1
//            self.totalPage = 1
//            self.searchedResult.removeAll()
//            searchContent(keyword: data, page: currentPage)
//        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange")
    }
    
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
