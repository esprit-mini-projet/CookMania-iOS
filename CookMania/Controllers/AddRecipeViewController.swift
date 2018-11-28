//
//  AddRecipeViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import iOSDropDown

class AddRecipeViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var addIngredientButton: UIButton!
    @IBOutlet var ingredientTableView: UITableView!
    
    var ingredients = [Ingredient(), Ingredient(), Ingredient()]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == ingredientTableView){
            return ingredients.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient")
        let contentView = cell?.viewWithTag(0)
        let quantity = contentView?.viewWithTag(1) as! ActionTextField
        let unit = contentView?.viewWithTag(2) as! DropDown
        let name = contentView?.viewWithTag(3) as! ActionTextField
        let deleteBtn = contentView?.viewWithTag(4) as! UIButton
        
        quantity.indexPath = indexPath
        quantity.addTarget(self, action: #selector(quantityDidChange(_:)), for: UIControl.Event.editingChanged)
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func quantityDidChange(_ sender: ActionTextField) {
        print("Text: " + sender.text! + " , for index: " + String(sender.indexPath!.row))
    }
    
    @IBAction func addIngredient(_ sender: Any) {
        
    }
    

}
