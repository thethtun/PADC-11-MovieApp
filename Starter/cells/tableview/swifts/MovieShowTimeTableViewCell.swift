//
//  MovieShowTimeTableViewCell.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 28/01/2021.
//

import UIKit

class MovieShowTimeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblSeeMore: UILabel!
    @IBOutlet weak var viewForbackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
//        viewForbackground.layer.cornerRadius = 4
        lblSeeMore.underlineText(text: "SEE MORE")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
