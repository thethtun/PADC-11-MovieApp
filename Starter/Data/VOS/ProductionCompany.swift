//
//  ProductionCompany.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import CoreData

// MARK: - ProductionCompany
public struct ProductionCompany: Codable {
    public let id: Int?
    public let logoPath: String?
    public let name, originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }

    func toProductionCompanyObject() -> ProductionCompanyObject {
        let object = ProductionCompanyObject()
        object.id = self.id!
        object.logoPath = self.logoPath
        object.name = self.name
        object.originCountry = self.originCountry
        return object
    }
    
    
    func toProductionCompanyEntity(context: NSManagedObjectContext) -> ProductionCompanyEntity {
        let entity = ProductionCompanyEntity(context: context)
        entity.id = Int32(self.id!)
        entity.logoPath = self.logoPath
        entity.name = self.name
        entity.originCountry = self.originCountry
        return entity
    }
}
