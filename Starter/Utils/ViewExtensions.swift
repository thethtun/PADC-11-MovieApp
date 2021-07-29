//
//  ViewExtensions.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 29/01/2021.
//

import Foundation
import UIKit

extension UILabel{
    
    func underlineText(text:String){
        let attributedString = NSMutableAttributedString.init(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}

extension UIButton {
    func underlineText(text:String){
        let attributedString = NSMutableAttributedString.init(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 0, length: attributedString.length))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UITableViewCell{
    static var identifier : String{
        String(describing: self)
    }
}


extension UITableView{
    
    func registerForCell(identifier:String){
        register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T:UITableViewCell>(identifier:String,indexPath:IndexPath)->T{
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return UITableViewCell() as! T
        }
        return cell
    }
}

extension UIViewController{
    func startLoading(yConstraint: Int = 0) {
        let loaderColor = UIColor.white
        let activityIndicator : UIActivityIndicatorView = {
            let ui = UIActivityIndicatorView()
            ui.translatesAutoresizingMaskIntoConstraints = false
            ui.style = UIActivityIndicatorView.Style.large
            ui.color = loaderColor
            ui.startAnimating()
            return ui
        }()
        
        let viewcontroller = self
        
        viewcontroller.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: viewcontroller.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: viewcontroller.view.centerYAnchor, constant: CGFloat(yConstraint)).isActive = true
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        let viewcontroller = self
        
        if let activityIndicator = viewcontroller.view.subviews.last,
           ((activityIndicator as? UIActivityIndicatorView) != nil){
            activityIndicator.removeFromSuperview()
        } else {
            print("Failed to stop loading")
        }
    }
    
    static var identifier : String{
        String(describing: self)
    }
}
