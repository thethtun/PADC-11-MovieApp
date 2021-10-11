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
    
    var viewModel: RxSearchContentVCViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RxSearchContentVCViewModel()
        
        // Do any additional setup after loading the view.
        initView()
        
        bindData()
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
        collectionViewResult.delegate = self
        collectionViewResult.showsHorizontalScrollIndicator = false
        collectionViewResult.showsVerticalScrollIndicator = false
        collectionViewResult.contentInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        if let layout = collectionViewResult.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        
        collectionViewResult.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
    }
   
    private func bindData() {
        addSearchBarObserver()
        addCollectionViewBindingObserver()
        addItemSelectedObserver()
        addPaginationObserver()
    }
    
    @objc func onClickDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension RxSearchContentVC {
    private func addSearchBarObserver() {
        searchBar.rx.text.orEmpty
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .do(onNext: { print($0)})
            .subscribe(onNext: { value in
                self.viewModel.handleSearchInputText(text: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func addCollectionViewBindingObserver() {
        viewModel.searchResultItems
            .bind(to: collectionViewResult.rx.items(
                    cellIdentifier: String(describing: PopularFilmCollectionViewCell.self),
                    cellType: PopularFilmCollectionViewCell.self))
            { row, element, cell in
                cell.data = element
            }
            .disposed(by: disposeBag)
    }
    
    private func addItemSelectedObserver() {
        collectionViewResult.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let items = try! self.viewModel.searchResultItems.value()
                let item = items[indexPath.row]
                self.navigateToMovieDetailViewController(movieId: item.id!)
            })
            .disposed(by: disposeBag)
    }
    
    private func addPaginationObserver() {
        Observable.combineLatest(
            collectionViewResult.rx.willDisplayCell,
            searchBar.rx.text.orEmpty)
            .subscribe(onNext : { (cellTuple, searchText) in
                self.viewModel.handlePagination(indexPath: cellTuple.1, searchText: searchText)
            })
            .disposed(by: disposeBag)
    }
    
}



//MARK: - UICollectionViewDelegateFlowLayout
extension RxSearchContentVC:UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalColumnSpacing : CGFloat = (viewModel.itemSpacing * CGFloat(viewModel.numberOfItemsPerRow - 1)) + collectionView.contentInset.left + collectionViewResult.contentInset.right
        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(viewModel.numberOfItemsPerRow)) - (totalColumnSpacing / CGFloat(viewModel.numberOfItemsPerRow))
        let itemHeight : CGFloat = (itemWidth * 1.5) + 80 /* For Text & Rating */
        return CGSize(width: itemWidth, height:  itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.itemSpacing
    }

}

