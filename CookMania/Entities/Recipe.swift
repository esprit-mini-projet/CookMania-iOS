//
//  Recipe.swift
//  CookMania
//
//  Created by Elyes on 11/4/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import ObjectMapper

class Recipe: Mappable{
    
    var id: Int?
    var name: String?
    var description: String?
    var calories: Int?
    var servings: Int?
    var imageUrl: String?
    var views: Int?
    var time: Int?
    var userId: String?
    var steps: [Step]?
    var labels: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        calories <- map["calories"]
        servings <- map["servings"]
        imageUrl <- map["image_url"]
        views <- map["views"]
        time <- map["time"]
        userId <- map["userId"]
        steps <- map["steps"]
        labels <- map["labels"]
    }
}
