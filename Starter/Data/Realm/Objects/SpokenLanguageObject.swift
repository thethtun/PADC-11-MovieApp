//
//  SpokenLanguageObject.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

class SpokenLanguageObject: Object {
    
    var iso639_1 : String?
    
    @Persisted(primaryKey: true)
    var name : String?
    
    @Persisted
    var englishName : String?
    
    func toSpokenLanguage() -> SpokenLanguage {
        SpokenLanguage(
            englishName: englishName,
            iso639_1: iso639_1,
            name: name)
    }
}
