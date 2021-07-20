//
//  GenreVO.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 28/01/2021.
//

import Foundation

class GenreVO {
    var id : Int = 0
    var name:String="ACTION"
    var isSelected:Bool=false
    
    init(id: Int = 0, name:String,isSelected:Bool) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}
