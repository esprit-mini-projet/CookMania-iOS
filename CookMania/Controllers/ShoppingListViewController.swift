//
//  ShoppingListViewController.swift
//  CookMania
//
//  Created by Elyes on 11/5/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cells = [Any]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let recipe = cells[indexPath.row] as? ShopRecipe {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Recipe")
            let content = cell?.viewWithTag(0)
            let imageView = content?.viewWithTag(1) as! UIImageView
            let nameLabel = content?.viewWithTag(2) as! UILabel
            imageView.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + recipe.imageUrl!)!)
            nameLabel.text = recipe.name
            return cell!
        }else{
            let ingredient = cells[indexPath.row] as! ShopIngredient
            let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient")
            let content = cell?.viewWithTag(0)
            let ingredientLabel = content?.viewWithTag(1) as! UILabel
            ingredientLabel.text = String("\(ingredient.quantity)\(ingredient.unit!) \(ingredient.name!)")
            let lineView = content?.viewWithTag(3)
            if ingredient.checked{
                lineView?.isHidden = false
            }else{
                lineView?.isHidden = true
            }
            let checkBox = content?.viewWithTag(2) as! VKCheckbox
            checkBox.borderWidth = 1
            checkBox.cornerRadius = 0
            checkBox.checkboxValueChangedBlock = {
                isOn in
                if isOn{
                    lineView?.isHidden = false
                }else{
                    lineView?.isHidden = true
                }
                ShopIngredientDao.getInstance().updateChecked(ingredient: ingredient, checked: isOn, completionHandler: {
                    //
                })
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recipe = cells[indexPath.row] as? ShopRecipe {
            RecipeService.getInstance().getRecipe(recipeId: Int(recipe.id)) { (recipe) in
                self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let recipe = cells[indexPath.row] as? ShopRecipe {
                ShopRecipeDao.getInstance().delete(recipeId: Int(recipe.id)) {
                    self.cells.removeAll()
                    self.getShoppingList()
                    self.tableView.reloadData()
                }
            }else{
                let ingredient = cells[indexPath.row] as! ShopIngredient
                ShopIngredientDao.getInstance().delete(ingredientId: Int(ingredient.id)) {
                    self.cells.removeAll()
                    self.getShoppingList()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetails"{
            let dest = segue.destination as! RecipeDetailsViewController
            dest.recipe = (sender as! Recipe)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cells.removeAll()
        getShoppingList()
        self.tableView.reloadData()
    }
    
    func getShoppingList(){
        for recipe in ShopRecipeDao.getInstance().getRecipes() {
            cells.append(recipe)
            for ingredient in recipe.ingredients!{
                cells.append(ingredient)
            }
        }
    }
    
    public func clearAll(){
        ShopRecipeDao.getInstance().deleteAll {
            self.cells.removeAll()
            self.tableView.reloadData()
        }
    }

}
