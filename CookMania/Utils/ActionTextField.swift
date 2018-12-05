//
//  ActionTextField.swift
//  CookMania
//
//  Created by Elyes on 11/27/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import UIKit

class ActionTextField: UITextField {
    var indexPath: IndexPath?
    
    convenience init(index: IndexPath){
        self.init()
        indexPath = index
    }
}
