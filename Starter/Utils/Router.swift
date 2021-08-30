//
//  Router.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 20/02/2021.
//

import Foundation
import UIKit

enum StoryboardName : String {
    case Main = "Main"
    case Authentication = "Authentication"
    case LaunchScreen = "LaunchScreen"
}

extension UIStoryboard{
    
    static func mainStoryBoard()->UIStoryboard{
        UIStoryboard(name: StoryboardName.Main.rawValue, bundle: nil)
    }
}

extension UIViewController {
    
    func navigateToSearchContentViewController() {
        let vc = RxSearchContentVC()
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
    }
    
    func navigateToViewMoreActorsViewController() {
        let vc = ViewMoreActorsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
    }
    
    func navigateToViewMoreMovieShowCaseViewController() {
        let vc = ViewMoreMovieShowCaseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
    }
    
    func navigateToActorDetailViewController(id : Int){
        let vc = ActorDetailViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        vc.itemId = id
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true)
    }
    
    func navigateToMovieDetailViewController(movieId : Int){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieDetailViewController.identifier) as? MovieDetailViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        vc.itemId = movieId
        vc.contentType = .movie
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true)
    }
    
    func navigateToSerieDetailViewController(id : Int){
        guard let vc = UIStoryboard.mainStoryBoard().instantiateViewController(identifier: MovieDetailViewController.identifier) as? MovieDetailViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        vc.itemId = id
        vc.contentType = .serie
        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true)
    }
    
}
