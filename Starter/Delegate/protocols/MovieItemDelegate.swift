//
//  MovieItemDelegate.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 20/02/2021.
//

import Foundation

public enum VideoType : String, Codable {
    case movie
    case serie
}

protocol MovieItemDelegate {
    func onTapMovie(id : Int, type : VideoType)
    func onTapViewMore(data: MovieListResponse)
}
