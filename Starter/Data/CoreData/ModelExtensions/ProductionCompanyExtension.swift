//
//  ProductionCompanyExtension.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

extension ProductionCompanyEntity {
    
    static func toProductionCompany(entity: ProductionCompanyEntity?) -> ProductionCompany {
        ProductionCompany(
            id: Int(entity?.id ?? 0),
            logoPath: entity?.logoPath,
            name: entity?.name,
            originCountry: entity?.originCountry)
    }
}
