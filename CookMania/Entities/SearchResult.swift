//
//  SearchResult.swift
//  CookMania
//
//  Created by Elyes on 12/22/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchResult : Mappable{
    var recipe: Recipe?
    var imageHeight: Float?
    var imageWidth: Float?
    
    init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        recipe <- map["recipe"]
        imageHeight <- map["height"]
        imageWidth <- map["width"]
    }
}
