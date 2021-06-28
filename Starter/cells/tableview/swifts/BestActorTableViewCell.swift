//
//  BestActorTableViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 31/01/2021.
//

import UIKit

class BestActorTableViewCell: UITableViewCell, ActorActionDelegate {
    
    @IBOutlet weak var lblMoreActors: UILabel!
    @IBOutlet weak var collectionViewActors: UICollectionView!
    @IBOutlet weak var heightCollectionViewActors : NSLayoutConstraint!
    
    var onClickActorView : ((Int)->Void)?
    
    var data : ActorListResponse? {
        didSet {
            if let _ = data {
                collectionViewActors.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMoreActors.underlineText(text: "MORE ACTORS")
        collectionViewActors.delegate = self
        collectionViewActors.dataSource = self
        collectionViewActors.register(UINib(nibName: String(describing: ActorCollectionViewCell
                                                                .self), bundle: nil), forCellWithReuseIdentifier: String(describing: ActorCollectionViewCell.self))
        
        
        let itemWidth : CGFloat = 120
        let itemHeight : CGFloat = itemWidth * 1.5
        heightCollectionViewActors.constant = itemHeight
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onTapFavorite(isFavorte: Bool) {
        debugPrint("isFavorite => \(isFavorte)")
    }
    
}

extension BestActorTableViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ActorCollectionViewCell.self), for: indexPath) as? ActorCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.data = data?.results?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth : CGFloat = 120
        let itemHeight : CGFloat = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = data?.results?[indexPath.row].id {
            onClickActorView?(id)
        } else {
            print("Invalid Actor ID!")
        }
    }
    
}
