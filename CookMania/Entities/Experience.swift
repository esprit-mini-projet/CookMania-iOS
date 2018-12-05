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
    private var dateString: String?
    var date: Date?
    
    var description: String {
        return "<\(type(of: self)): user = \(String(describing: user)), rating = \(String(describing: rating)), comment = \(String(describing: comment)), imageURL = \(String(describing: imageURL)), date = \(String(describing: date))>"
    }
    
    init(user: User, rating: Float, comment: String, imageUrl: String) {
        self.user = user
        self.rating = rating
        self.comment = comment
        self.imageURL = imageUrl
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user <- map["user"]
        //recipe <- map["recipe"]
        rating <- map["rating"]
        comment <- map["comment"]
        imageURL <- map["image_url"]
        dateString <- map["date"]
        
        let dateFroamtter = DateFormatter()
        dateFroamtter.locale = Locale(identifier: "en_US_POSIX")
        dateFroamtter.timeZone = TimeZone.autoupdatingCurrent
        dateFroamtter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        date = dateFroamtter.date(from: dateString!)
    }
}
