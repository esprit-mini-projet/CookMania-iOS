//
//  Experience.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/15/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import ObjectMapper

class Experience: Mappable {
    
    var user: User?
    //var recipe: Recipe?
    var rating: Float?
    var comment: String?
    var imageURL: String?
    var date: String?
    
    var description: String {
        return "<\(type(of: self)): user = \(String(describing: user)), rating = \(String(describing: rating)), comment = \(String(describing: comment)), imageURL = \(String(describing: imageURL)), date = \(String(describing: date))>"
    }
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user <- map["user"]
        //recipe <- map["recipe"]
        rating <- map["rating"]
        comment <- map["comment"]
        imageURL <- map["image_url"]
        date <- map["date"]
    }
}
