//
//  CommunityViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/10/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {
    
    var controller: ShoppingListViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShoppingList"{
            controller = (segue.destination as! ShoppingListViewController)
        }
    }
    
    @IBAction func clearShoppingList(_ sender: Any) {
        controller!.clearAll()
    }
}
