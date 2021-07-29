//
//  GenreEntityExtension.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

extension GenreEntity {
    
    static func toMovieGenre(entity : GenreEntity) -> MovieGenre {
        MovieGenre(id: Int(entity.id ?? "0") ?? 0, name: entity.name ?? "")
    }
}
