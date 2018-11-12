//
//  User.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String?
    var email: String
    var username: String
    var imageUrl: String?
    var date: Date?
    var following: Int = 0
    var followers: Int = 0
    
    override var description: String { return "User: {id: \(id!) , email: \(email) , username: \(username) , imageUrl: \(imageUrl!), date: \(date!), following: \(following), followers: \(followers) }" }
    //override public var description: String { return "User: {id: \(id) , email: \(email) , firtname: \(firstName) , lastname \(lastName) , imageUrl: \(imageUrl) }"}
    
    init(id: String, email: String, username: String, imageUrl: String, date: Date, following: Int, followers: Int) {
        self.id = id
        self.email = email
        self.username = username
        self.imageUrl = imageUrl
        self.date = date
        self.following = following
        self.followers = followers
    }
    
    init(email: String, username: String, imageUrl: String, date: Date, following: Int, followers: Int) {
        self.email = email
        self.username = username
        self.imageUrl = imageUrl
        self.date = date
        self.following = following
        self.followers = followers
    }
}
