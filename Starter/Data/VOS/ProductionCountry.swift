//
//  ProductionCountry.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import CoreData

// MARK: - ProductionCountry
public struct ProductionCountry: Codable {
    public let iso3166_1, name: String?

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
    
    func toProductionCountryObject() -> ProductionCountryObject {
        let object = ProductionCountryObject()
        object.iso3166_1 = self.iso3166_1
        object.name = self.name
        return object
    }
    
    func toProductionCountryEntity(context: NSManagedObjectContext) -> ProductionCountryEntity {
        let entity = ProductionCountryEntity(context: context)
        entity.iso3166_1 = self.iso3166_1
        entity.name = self.name
        return entity
    }
    
}
