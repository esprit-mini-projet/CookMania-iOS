//
//  SuggestionImageView.swift
//  CookMania
//
//  Created by Elyes on 12/9/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import UIKit

class SuggestionImageView: UIImageView {
    var recipe: Recipe?
    
    convenience init(recipe: Recipe){
        self.init()
        self.recipe = recipe
    }
}
