//
//  User.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import ObjectMapper

class User: Mappable {
    var id: String?
    var email: String?
    var username: String?
    var password: String?
    var imageUrl: String?
    var date: Date?
    var following: Int = 0
    var followers: Int = 0
    
    var description: String {
        return "<\(type(of: self)): id = \(String(describing: id)), email = \(String(describing: email)), username = \(String(describing: username)), password = \(String(describing: password)), imageUrl = \(String(describing: imageUrl)), date = \(String(describing: date)), following = \(String(describing: following)), followers = \(String(describing: followers))>"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        username <- map["username"]
        password <- map["password"]
        imageUrl <- map["image_url"]
        date <- map["date"]
        following <- map["following"]
        followers <- map["followers"]
    }
    
    init(id: String, email: String, username: String, password: String, imageUrl: String, date: Date, following: Int, followers: Int) {
        self.id = id
        self.email = email
        self.username = username
        self.password = password
        self.imageUrl = imageUrl
        self.date = date
        self.following = following
        self.followers = followers
    }
    
    init(email: String, username: String, password: String, imageUrl: String, date: Date, following: Int, followers: Int) {
        self.email = email
        self.username = username
        self.password = password
        self.imageUrl = imageUrl
        self.date = date
        self.following = following
        self.followers = followers
    }
    
    init(email: String, username: String, password: String) {
        self.email = email
        self.username = username
        self.password = password
    }
    
    init(email: String, username: String) {
        self.email = email
        self.username = username
    }
    
    init(id: String, email: String, username: String, imageUrl: String) {
        self.id = id
        self.email = email
        self.username = username
        self.imageUrl = imageUrl
    }
}
