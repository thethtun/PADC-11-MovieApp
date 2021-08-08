//
//  Helpers.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

extension Array {
    func appendItems<T: Object>(to realmList: List<T>) {
        self.forEach {
            if let object = $0 as? T {
                realmList.append(object)
            }
        }
    }
    
    func toRealmList<T: Object>() -> List<T> {
        let list = List<T>()
        
        self.forEach {
            if let object = $0 as? T {
                list.append(object)
            }
        }
        
        return list
    }
}
