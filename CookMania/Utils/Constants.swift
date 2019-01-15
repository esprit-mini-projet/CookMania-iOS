//
//  Constants.swift
//  CookMania
//
//  Created by Elyes on 11/14/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation

struct Constants {
    
    static let ipAddress = "http://192.168.30.128:3000"
    
    struct URL {
        static let topRatedRecipes = ipAddress + "/recipes/top"
        static let imagesFolder = ipAddress + "/public/images/"
    }
}
