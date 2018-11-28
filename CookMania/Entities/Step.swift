//
//  Step.swift
//  CookMania
//
//  Created by Elyes on 11/14/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import ObjectMapper

class Step: Mappable{
    
    var id: Int?
    var description: String?
    var imageUrl: String?
    var time: Int?
    var ingredients: [Ingredient]?
    
    init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        description <- map["description"]
        imageUrl <- map["imageUrl"]
        time <- map["time"]
        ingredients <- map["ingredients"]
    }
    
}
