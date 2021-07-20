//
//  ShowCaseCollectionViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 29/01/2021.
//

import UIKit

class ShowCaseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelContentTitle : UILabel!
    @IBOutlet weak var imageViewBackdrop : UIImageView!
    @IBOutlet weak var labelReleaseDate : UILabel!
    
    var data : MovieResult? {
        didSet {
            if let data = data {
                let title = data.originalTitle ?? data.originalName
                let backdropPath = "\(AppConstants.baseImageUrl)/\(data.backdropPath ?? "")"
                
                labelContentTitle.text = title
                imageViewBackdrop.sd_setImage(with: URL(string: backdropPath))
                labelReleaseDate.text = data.releaseDate ?? "undefined"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
