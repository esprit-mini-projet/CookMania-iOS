//
//  Ingredient.swift
//  CookMania
//
//  Created by Elyes on 11/14/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import ObjectMapper

class Ingredient: Mappable{
    
    var id: Int?
    var name: String?
    var quantity: Int?
    var unit: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        quantity <- map["quantity"]
        unit <- map["unit"]
    }
    
}
