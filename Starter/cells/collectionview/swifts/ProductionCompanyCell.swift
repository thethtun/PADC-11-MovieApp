//
//  ProductionCompanyCell.swift
//  Starter
//
//  Created by Thet Htun on 5/25/21.
//

import UIKit

class ProductionCompanyCell: UICollectionViewCell {

    @IBOutlet weak var imageViewBackdrop : UIImageView!
    @IBOutlet weak var labelCompanyName : UILabel!
    
    var data : ProductionCompany? {
        didSet {
            if let data = data {
                let urlStr = "\(AppConstants.baseImageUrl)/\(data.logoPath ?? "")"
                imageViewBackdrop.sd_setImage(with: URL(string: urlStr))
                
                if data.logoPath == nil || data.logoPath!.isEmpty {
                    labelCompanyName.text = data.name
                } else {
                    labelCompanyName.text = ""
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
