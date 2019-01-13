//
//  ActionImageView.swift
//  CookMania
//
//  Created by Elyes on 1/5/19.
//  Copyright © 2019 MiniProjet. All rights reserved.
//

import Foundation
import UIKit

class ActionImageView: UIImageView {
    var data: String?
    
    convenience init(data: String){
        self.init()
        self.data = data
    }
}
