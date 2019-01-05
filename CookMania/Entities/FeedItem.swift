//
//  FeedItem.swift
//  CookMania
//
//  Created by Elyes on 1/4/19.
//  Copyright © 2019 MiniProjet. All rights reserved.
//

import Foundation
import ObjectMapper

class FeedItem : Mappable{
    var recipe: Recipe?
    var user: User?
    
    init(){
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        recipe <- map["recipe"]
        user <- map["user"]
    }
}
