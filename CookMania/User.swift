//
//  User.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/7/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class User: NSObject {
    var id: String
    var email: String
    var imageUrl: String
    var firstName: String
    var lastName: String
    
    override public var description: String { return "User: {id: \(id) , email: \(email) , firtname: \(firstName) , lastname: \(lastName) , imageUrl: \(imageUrl) }"}
    
    init(id: String, email: String, firstName: String, lastName: String, imageUrl: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.imageUrl = imageUrl
    }
}
