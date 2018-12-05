//
//  ActionSegmentControl.swift
//  CookMania
//
//  Created by Elyes on 11/28/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import UIKit

class ActionSegmentControl: UISegmentedControl {
    var indexPath: IndexPath?
    
    convenience init(index: IndexPath){
        self.init()
        indexPath = index
    }
}
