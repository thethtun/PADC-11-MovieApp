//
//  ActorActionDelegate.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 31/01/2021.
//

import Foundation

protocol ActorActionDelegate {
    
    func onTapFavorite(isFavorte:Bool)
    func onTapItem(data : ActorInfoResponse)
}
