//
//  MenuItem.swift
//  CookMania
//
//  Created by Seif Abdennadher on 12/23/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class MenuItem {
    
    var name: String
    var icon: UIImage
    var iconTintColor: UIColor
    var clickHandler: (() -> ())
    
    init(name: String, icon: UIImage, iconTintColor: UIColor, clickHandler: @escaping (() -> ())) {
        self.name = name
        self.icon = icon
        self.clickHandler = clickHandler
        self.iconTintColor = iconTintColor
    }

}
