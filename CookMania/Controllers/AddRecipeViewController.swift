//
//  AddRecipeViewController.swift
//  CookMania
//
//  Created by Elyes on 12/7/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addSteps(_ sender: Any) {
        performSegue(withIdentifier: "toAddStep", sender: nil)
    }
    
}
