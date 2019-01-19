//
//  OfflineShoppingListViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 1/19/19.
//  Copyright © 2019 MiniProjet. All rights reserved.
//

import UIKit

class OfflineShoppingListViewController: UIViewController {

    var controller: ShoppingListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShoppingList" {
            controller = segue.destination as? ShoppingListViewController
        }
    }
    
    
    @IBAction func clearAll(_ sender: Any) {
        controller?.clearAll()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
