//
//  ActorCollectionViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 31/01/2021.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivHeart: UIImageView!
    @IBOutlet weak var ivHeartFill: UIImageView!
    @IBOutlet weak var imageViewActorProfile : UIImageView!
    @IBOutlet weak var labelActorName : UILabel!
    @IBOutlet weak var labelKnownForDepartment : UILabel!
    
    weak var delegate : ActorActionDelegate? = nil
    
    var data : ActorInfoResponse? {
        didSet {
            if let data = data {
                let posterPath = "\(AppConstants.baseImageUrl)/\(data.profilePath ?? "")"
                imageViewActorProfile.sd_setImage(with: URL(string:  posterPath), completed: nil)
                labelActorName.text = data.name
                labelKnownForDepartment.text = data.knwonForDepartment
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initGestureRecognizers()
    }
    
    private func initGestureRecognizers(){
        let tapGestForFavorite = UITapGestureRecognizer(target: self, action: #selector(onTapFavorite))
        ivHeartFill.isUserInteractionEnabled = true
        ivHeartFill.addGestureRecognizer(tapGestForFavorite)
        
        let tapGestForUnFavorite = UITapGestureRecognizer(target: self, action: #selector(onTapUnFavorite))
        ivHeart.isUserInteractionEnabled = true
        ivHeart.addGestureRecognizer(tapGestForUnFavorite)
        
        let tapGestForItem = UITapGestureRecognizer(target: self, action: #selector(onTapItem))
        self.contentView.isUserInteractionEnabled = true
        self.contentView.addGestureRecognizer(tapGestForItem)
    }
    
    @objc func onTapItem() {
        delegate?.onTapItem(data: data!)
    }
    
    @objc func onTapFavorite(){
        ivHeartFill.isHidden = true
        ivHeart.isHidden = false
        delegate?.onTapFavorite(isFavorte: true)
    }
    
    @objc func onTapUnFavorite(){
        ivHeart.isHidden = true
        ivHeartFill.isHidden = false
        delegate?.onTapFavorite(isFavorte: false)
    }

}
