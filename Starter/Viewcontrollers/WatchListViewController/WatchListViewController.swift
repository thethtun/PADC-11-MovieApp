//
//  WatchListViewController.swift
//  Starter
//
//  Created by Thet Htun on 8/5/21.
//

import UIKit

class WatchListViewController: UIViewController {

    @IBOutlet weak var collectionViewWatchList : UICollectionView!
    
    private let numberOfItemsInRow : CGFloat = 3
    private let contentInsetCollectionView : CGFloat = 10
    private let minimumInterItemSpacing : CGFloat = 10
    
    private let watchListModel : WatchListModel = WatchListModelImpl.shared
    
    private var dataSource = [MovieResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        initData()
    }
    
    func initView() {
        setupCollectionView()
    }

    func setupCollectionView() {
        collectionViewWatchList.dataSource = self
        collectionViewWatchList.delegate = self
        collectionViewWatchList.showsHorizontalScrollIndicator = false
        collectionViewWatchList.showsVerticalScrollIndicator = false
        if let layout = collectionViewWatchList.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        collectionViewWatchList.backgroundColor = UIColor(named: "color_primary")
        collectionViewWatchList.contentInset = UIEdgeInsets.init(top: contentInsetCollectionView, left: contentInsetCollectionView, bottom: contentInsetCollectionView, right: contentInsetCollectionView)
        collectionViewWatchList.register(UINib(nibName: String(describing: PopularFilmCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self))
    }

    private func initData() {
//        watchListModel.getWatchListItems { [unowned self] (results) in
//            switch results {
//            case .success(let items):
//                self.dataSource = items
//                self.collectionViewWatchList.reloadData()
//            case .failure(let msg):
//                print(msg)
//            }
//        }
     
        watchListModel.initFetchResultController(subscription: self)
    }
    
    deinit {
        watchListModel.deinitFetchResultController()
    }
}

extension WatchListViewController: WatchListRepoSubscription {
    func onFetchResultDidChange(didChange objects: [MovieResult]) {
        self.dataSource = objects
        self.collectionViewWatchList.reloadData()
    }
}


//MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension WatchListViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PopularFilmCollectionViewCell.self), for: indexPath) as? PopularFilmCollectionViewCell else { return UICollectionViewCell() }
        cell.data = dataSource[indexPath.row]
        cell.onTapItem = { [unowned self] (id, type) in
            switch type {
            case .movie:
                navigateToMovieDetailViewController(movieId : id)
            case .serie:
                navigateToSerieDetailViewController(id: id)
            }
        }
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension WatchListViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing : CGFloat = (minimumInterItemSpacing * CGFloat(numberOfItemsInRow - 1)) + collectionView.contentInset.left + collectionView.contentInset.right
        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(numberOfItemsInRow)) - (totalSpacing / CGFloat(numberOfItemsInRow))
        let itemHeight : CGFloat = itemWidth * 2.1
        return CGSize(width: itemWidth, height:  itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemSpacing
    }
    
}
