//
//  ProductionCountryEntityExtension.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation


extension ProductionCountryEntity {
    
    static func toProductionCountry(entity: ProductionCountryEntity?) -> ProductionCountry {
        ProductionCountry(iso3166_1: entity?.iso3166_1, name: entity?.name)
    }
}
