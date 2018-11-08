//
//  Recipe.swift
//  CookMania
//
//  Created by Elyes on 11/4/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation

class Recipe{
    
    var name: String?
    var image: String?
    var ingredients = [String]()
    
    init(name: String?, image: String?, ingredients: [String]) {
        self.name = name
        self.image = image
        self.ingredients = ingredients
    }
}
