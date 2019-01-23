//
//  ShoppingListViewController.swift
//  CookMania
//
//  Created by Elyes on 11/5/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import EasyTipView
import SwiftKeychainWrapper

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EasyTipViewDelegate {
    
    let SEEN_SWIPE_HINT_KEY = "swipe_hint"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var cells = [Any]()
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        KeychainWrapper.standard.set(true, forKey: SEEN_SWIPE_HINT_KEY)
    }
    
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
            let checkBox = content?.viewWithTag(2) as! VKCheckbox
            ingredientLabel.text = String("\(ingredient.quantity)\(ingredient.unit!) \(ingredient.name!)")
            let lineView = content?.viewWithTag(3)
            if ingredient.checked{
                lineView?.isHidden = false
                checkBox.setOn(true, animated: true)
            }else{
                lineView?.isHidden = true
                checkBox.setOn(false, animated: false)
            }
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
                    if self.cells.isEmpty{
                        self.tableView.isHidden = true
                        self.emptyLabel.isHidden = false
                    }else{
                        self.tableView.isHidden = false
                        self.emptyLabel.isHidden = true
                    }
                }
            }else{
                let ingredient = cells[indexPath.row] as! ShopIngredient
                ShopIngredientDao.getInstance().delete(ingredientId: Int(ingredient.id)) {
                    self.cells.removeAll()
                    self.getShoppingList()
                    self.tableView.reloadData()
                    if self.cells.isEmpty{
                        self.tableView.isHidden = true
                        self.emptyLabel.isHidden = false
                    }else{
                        self.tableView.isHidden = false
                        self.emptyLabel.isHidden = true
                    }
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
        if cells.isEmpty{
            self.tableView.isHidden = true
            self.emptyLabel.isHidden = false
        }else{
            self.tableView.isHidden = false
            self.emptyLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !cells.isEmpty{
            if !(KeychainWrapper.standard.bool(forKey: SEEN_SWIPE_HINT_KEY) ?? false){
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                EasyTipView(text: "You can swipe left to remove an element. Tap to dismiss.", preferences: EasyTipView.globalPreferences, delegate: self).show(forView: cell!, withinSuperview: tableView)
            }
        }
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
            self.tableView.isHidden = true
            self.emptyLabel.isHidden = false
        }
    }

}
