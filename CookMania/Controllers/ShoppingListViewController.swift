//
//  ShoppingListViewController.swift
//  CookMania
//
//  Created by Elyes on 11/5/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDataSource {
    
    var cells = [Any]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let recipe = cells[indexPath.row] as? Recipe {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Recipe")
            /*let content = cell?.viewWithTag(0)
            let imageView = content?.viewWithTag(1) as! UIImageView
            let nameLabel = content?.viewWithTag(2) as! UILabel
            imageView.image = UIImage(named: recipe.image!)
            nameLabel.text = recipe.name*/
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient")
            /*let content = cell?.viewWithTag(0)
            let ingredientLabel = content?.viewWithTag(1) as! UILabel
            ingredientLabel.text = cells[indexPath.row] as? String
            let checkBox = content?.viewWithTag(2) as! VKCheckbox
            checkBox.borderWidth = 1
            checkBox.cornerRadius = 0*/
            return cell!
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*for recipe in recipes {
            cells.append(recipe)
            for ingredient in recipe.ingredients{
                cells.append(ingredient)
            }
        }*/
    }

}
