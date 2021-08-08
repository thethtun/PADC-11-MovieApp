//
//  SpokenLanguage.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import CoreData

// MARK: - SpokenLanguage
public struct SpokenLanguage: Codable {
    public let englishName, iso639_1, name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
    
    func toSpokenLanguageObject() -> SpokenLanguageObject {
        let object = SpokenLanguageObject()
        object.englishName = self.englishName
        object.iso639_1 = self.iso639_1
        object.name = self.name
        return object
    }

    func toSpokenLanguageEntity(context: NSManagedObjectContext) -> SpokenLanguageEntity {
        let entity = SpokenLanguageEntity(context: context)
        entity.englishName = self.englishName
        entity.iso639_1 = self.iso639_1
        entity.name = self.name
        return entity
    }
}
