//
//  ViewMoreActorsViewController.swift
//  Starter
//
//  Created by Thet Htun on 6/28/21.
//

import UIKit

class ViewMoreActorsViewController: UIViewController {

    @IBOutlet weak var collectionViewActors : UICollectionView!
    
    private var data : [ActorInfoResponse] = []
    
    private let networkAgent = MovieDBNetworkAgent.shared
    private let actorModel : ActorModel = ActorModelImpl.shared
    
    private let itemSpacing : CGFloat = 10
    private let numberOfItemsPerRow = 3
    private var currentPage : Int = 1
    private var totalPage : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        fetchData(page: currentPage)
    }
    
    private func initView() {
        setupCollectionView()
        
        self.navigationItem.title = "Popular Actors"
    }
    
    private func fetchData(page : Int) {
        self.startLoading()
        actorModel.getPopularPeople(page : page) { [weak self] (result) in
            guard let self = self else { return }
            self.stopLoading()
            switch result {
            case .success(let data):
                self.data.append(contentsOf: data)
                self.totalPage = self.actorModel.totalPageActorList
                self.collectionViewActors.reloadData()
            case .failure(let message):
                print(message.debugDescription)
            }
        }

    }

    func setupCollectionView() {
        collectionViewActors.dataSource = self
        collectionViewActors.delegate = self
        collectionViewActors.showsHorizontalScrollIndicator = false
        collectionViewActors.showsVerticalScrollIndicator = false
        collectionViewActors.contentInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 16, right: 16)
        if let layout = collectionViewActors.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical  // .horizontal
        }
        
        collectionViewActors.register(UINib(nibName: String(describing: ActorCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ActorCollectionViewCell.self))
        
    }

}

//MARK: - UICollectionViewDelegate,UICollectionViewDataSource
extension ViewMoreActorsViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ActorCollectionViewCell.self), for: indexPath) as? ActorCollectionViewCell else { return UICollectionViewCell() }
        
        cell.data = data[indexPath.row]
        cell.delegate = self
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isAtLastRow = indexPath.row == (data.count - 1)
        let hasMorePages = self.currentPage < self.totalPage
        if isAtLastRow && hasMorePages {
            currentPage = currentPage + 1
            fetchData(page: currentPage)
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewMoreActorsViewController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing : CGFloat = (itemSpacing * CGFloat(numberOfItemsPerRow - 1)) + collectionView.contentInset.left + collectionViewActors.contentInset.right
        let itemWidth : CGFloat = (collectionView.frame.width / CGFloat(numberOfItemsPerRow)) - (totalSpacing / CGFloat(numberOfItemsPerRow))
        let itemHeight : CGFloat = itemWidth * 1.5
        return CGSize(width: itemWidth, height:  itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
   
    
}


extension ViewMoreActorsViewController : ActorActionDelegate {
    func onTapFavorite(isFavorte: Bool) {
        
    }
    
    func onTapItem(data: ActorInfoResponse) {
        navigateToActorDetailViewController(id: data.id ?? 1)
    }
}
