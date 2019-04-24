//
//  RecipeListViewController.swift
//  CookMania
//
//  Created by Elyes on 11/4/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class RecipeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var label: String? = nil
    var recipeList = [Recipe]()
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recipe")
        let imageView = cell?.viewWithTag(1) as! UIImageView
        let nameLabel = cell?.viewWithTag(2) as! UILabel
        let ratingLabel = cell?.viewWithTag(3) as! UILabel
        let caloriesLabel = cell?.viewWithTag(4) as! UILabel
        let servingsLabel = cell?.viewWithTag(5) as! UILabel
        imageView.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + recipeList[indexPath.row].imageUrl!)!)
        nameLabel.text = recipeList[indexPath.row].name
        ratingLabel.text = String(recipeList[indexPath.row].rating!)
        caloriesLabel.text = String(recipeList[indexPath.row].calories!)
        servingsLabel.text = String(recipeList[indexPath.row].servings!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipeList[indexPath.item]
        RecipeService.getInstance().getRecipe(recipeId: recipe.id!, completionHandler: { recipe in
            self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeDetails" {
            let destination = segue.destination as! RecipeDetailsViewController
            let recipe = sender as! Recipe
            destination.recipe = recipe
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.label!
        fetchData()
    }
    
    func fetchData(){
        Loader.getInstance().startLoader()
        if label == "Top Rated" {
            RecipeService.getInstance().getTopRecipes { (recipes: [Recipe]) in
                self.recipeList = recipes
                self.recipeTableView.reloadData()
                Loader.getInstance().stopLoader()
            }
        } else {
            RecipeService.getInstance().getRecipesByLabel(label: label!) { (recipes: [Recipe]) in
                self.recipeList = recipes
                self.recipeTableView.reloadData()
                Loader.getInstance().stopLoader()
            }
        }
    }
}
