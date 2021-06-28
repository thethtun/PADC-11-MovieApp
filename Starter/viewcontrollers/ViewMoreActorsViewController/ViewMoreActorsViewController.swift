//
//  ViewMoreActorsViewController.swift
//  Starter
//
//  Created by Thet Htun on 6/28/21.
//

import UIKit

class ViewMoreActorsViewController: UIViewController {

    @IBOutlet weak var collectionViewActors : UICollectionView!
    
    var initData : ActorListResponse?

    private var data : [ActorInfoResponse] = []
    
    private let itemSpacing : CGFloat = 10
    private let numberOfItemsPerRow = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        initState()
    }
    
    private func initView() {
        setupCollectionView()
    }
    
    private func initState() {
        data.append(contentsOf: initData?.results ?? [ActorInfoResponse]())
        collectionViewActors.reloadData()
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
        
        return cell
        
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

