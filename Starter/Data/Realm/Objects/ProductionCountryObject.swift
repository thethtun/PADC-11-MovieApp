//
//  ProductionCountryObject.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

class ProductionCountryObject: Object {
    
    @Persisted(primaryKey: true)
    var iso3166_1: String?
    
    @Persisted
    var name: String?
    
    func toProductionCountry() -> ProductionCountry {
        ProductionCountry(iso3166_1: iso3166_1, name: name)
    }
}
