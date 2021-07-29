//
//  SpokenLanguageEntityExtension.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

extension SpokenLanguageEntity {
    
    static func toSpokenLanguage(entity: SpokenLanguageEntity?) -> SpokenLanguage {
        SpokenLanguage(
            englishName: entity?.englishName,
            iso639_1: entity?.iso639_1,
            name: entity?.name)
    }
}
