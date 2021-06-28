//
//  GenreCollectionViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 28/01/2021.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var viewForOverlay: UIView!
    @IBOutlet weak var lblGenre: UILabel!
    
    var onTapItem : ((Int)->Void) = {_ in}
    
    var data : GenreVO? = nil{
        didSet{
            if let genre = data{
                lblGenre.text = genre.name.uppercased()
                (genre.isSelected) ? (viewForOverlay.isHidden=false) : (viewForOverlay.isHidden=true)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureForContainer = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tapGestureForContainer)
    }
    
    @objc func didTapItem(){
        onTapItem(data?.id ?? 0)
    }
    
}
