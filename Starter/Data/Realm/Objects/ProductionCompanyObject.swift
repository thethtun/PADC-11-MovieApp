//
//  ProductionCompanyObject.swift
//  Starter
//
//  Created by Thet Htun on 8/8/21.
//

import Foundation
import RealmSwift

class ProductionCompanyObject: Object {
    @Persisted(primaryKey: true)
    var id: Int

    @Persisted
    var logoPath: String?
    
    @Persisted
    var name: String?
    
    @Persisted
    var originCountry: String?
    
    func toProductionCompany() -> ProductionCompany {
        ProductionCompany(
            id: id,
            logoPath: logoPath,
            name: name,
            originCountry: originCountry)
    }
}
