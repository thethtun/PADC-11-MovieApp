//
//  PopularFilmCollectionViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 23/01/2021.
//

import UIKit

class PopularFilmCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelContentTitle : UILabel!
    @IBOutlet weak var imageViewBackdrop : UIImageView!
    @IBOutlet weak var ratingStar : RatingControl!
    @IBOutlet weak var labelRating : UILabel!
    @IBOutlet weak var containerView : UIView!
    @IBOutlet weak var labelTitleHint : UILabel!
    
    var onTapItem : ((Int, VideoType)->Void)?
    
    var data : MovieResult? {
        didSet {
            if let data = data {
                let title = data.originalTitle ?? data.originalName
                let backdropPath = "\(AppConstants.baseImageUrl)/\(data.posterPath ?? "")"
                
                labelContentTitle.text = title
                labelTitleHint.text = title
                imageViewBackdrop.sd_setImage(with: URL(string: backdropPath))
                
                let voteAverage = data.voteAverage ?? 0.0
                labelRating.text = "\(voteAverage)" //max - 10
                ratingStar.starCount = Int(voteAverage * 0.5) //max - 5
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureForContainer = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
        containerView.isUserInteractionEnabled = true
        tapGestureForContainer.cancelsTouchesInView = false
        containerView.addGestureRecognizer(tapGestureForContainer)
    }

    @objc func didTapItem(){
        onTapItem?(data?.id ?? 0, data?.getVideoType() ?? .movie)
    }

}
