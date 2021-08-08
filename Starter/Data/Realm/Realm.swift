//
//  Realm.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

class MovieDBRealm {
    
    static let shared : MovieDBRealm = MovieDBRealm()
    
    let db = try! Realm()
    
    private init() {
        print("Realm DB file path - \(db.configuration.fileURL!.absoluteURL.absoluteString)")
    }
    
//    func write(_ object : Object) {
//        do {
//            try db.write {
//                db.add(object, update: .modified)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    func write<T: List<Object>>(_ objects : T) {
//        do {
//            try db.write {
//                db.add(objects, update: .modified)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
    
}

extension Object {
    func toList() -> List<Object> {
        let list = List<Object>()
        list.append(self)
        return list
    }
}


