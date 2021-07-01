//
//  RatingControl.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 14/01/2021.
//

import UIKit

@IBDesignable
class RatingControl: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var starSize : CGSize = CGSize(width: 50.0, height: 50.0){
        didSet{
            setUpButtons()
            updateButtonRating()
        }
    }
    
    
    @IBInspectable var starCount : Int = 5{
        didSet{
            setUpButtons()
            updateButtonRating()
        }
    }
    
    @IBInspectable var rating : Int = 3{
        didSet{
            updateButtonRating()
        }
    }
    
    var ratingButtons = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
        updateButtonRating()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
        updateButtonRating()
    }
    
    private func setUpButtons(){
        
        clearExistingButton()
        
        for _ in 0..<starCount {
            
            let button = UIButton()
            
            button.setImage(UIImage(named: "filledStar"), for: .selected)
            button.setImage(UIImage(named: "emptyStar"), for: .normal)
            
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            addArrangedSubview(button)
            button.isUserInteractionEnabled = false
            
            ratingButtons.append(button)
        }
        
    }
    
    
    private func updateButtonRating(){
        for (index,button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    private func clearExistingButton(){
        for button in ratingButtons{
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
    }
    
}
