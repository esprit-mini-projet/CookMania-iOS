//
//  RecipeDetailsViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Cosmos

class RecipeDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    class Ingredient: NSObject {
        var id: Int
        var name: String
        var quantity: Float
        var unit: String
        
        init(id: Int, name: String, quantity: Float, unit: String) {
            self.id = id
            self.name = name
            self.quantity = quantity
            self.unit = unit
        }
    }
    
    class Step: NSObject {
        var name: String
        var desc: String
        var time: Int
        var ingredients: [Ingredient]
        
        init(name: String, desc: String, time: Int, ingredients: [Ingredient]) {
            self.name = name
            self.desc = desc
            self.time = time
            self.ingredients = ingredients
        }
    }
    
    class Recipe: NSObject {
        var name: String
        var rating: Float
        var imageUrl: String
        var time: Int
        var calories: Int
        var servings: Int
        var steps: [Step]
        var ingredients: [Ingredient]
        
        init(name: String, rating: Float, imageUrl: String, time: Int, calories: Int, servings: Int, steps: [Step], ingredients: [Ingredient]){
            self.name = name
            self.rating = rating
            self.imageUrl = imageUrl
            self.time = time
            self.calories = calories
            self.servings = servings
            self.steps = steps
            self.ingredients = ingredients
        }
    }
    
    @IBOutlet weak var recipeCoverIV: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ingredientsStack: UIStackView!
    @IBOutlet weak var servingsStack: UIStackView!
    @IBOutlet weak var ingredientsValueLabel: UILabel!
    @IBOutlet weak var caloriesValueLabel: UILabel!
    @IBOutlet weak var servingsValueLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stepsTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientsTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var similarRecipesCollectionView: UICollectionView!
    
    var recipe = Recipe(name: "Melanzana", rating: 3.0, imageUrl: "melanzana", time: 20, calories: 367, servings: 4, steps: [
            Step(name: "Prepare tatatata", desc: "", time: 0, ingredients: []),
            Step(name: "Cook the sauce", desc: "Let it simmer for 3 mintues", time: 4, ingredients: [
                    Ingredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                    Ingredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                    Ingredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
                ]),
            Step(name: "Let rest for 4 minutes", desc: "", time: 4, ingredients: [])
        ], ingredients: [
            Ingredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
            Ingredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
            Ingredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
        ])
    
    var similarRecipes = [
        Recipe(name: "Melanzana", rating: 3.0, imageUrl: "melanzana", time: 20, calories: 367, servings: 4, steps: [
            Step(name: "Prepare tatatata", desc: "", time: 0, ingredients: []),
            Step(name: "Cook the sauce", desc: "Let it simmer for 3 mintues", time: 4, ingredients: [
                Ingredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                Ingredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                Ingredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
                ]),
            Step(name: "Let rest for 4 minutes", desc: "", time: 4, ingredients: [])
            ], ingredients: [
                Ingredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                Ingredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                Ingredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
            ]
        ),
        Recipe(name: "Melanzana", rating: 3.0, imageUrl: "melanzana", time: 20, calories: 367, servings: 4, steps: [
            Step(name: "Prepare tatatata", desc: "", time: 0, ingredients: []),
            Step(name: "Cook the sauce", desc: "Let it simmer for 3 mintues", time: 4, ingredients: [
                Ingredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                Ingredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                Ingredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
                ]),
            Step(name: "Let rest for 4 minutes", desc: "", time: 4, ingredients: [])
            ], ingredients: [
                Ingredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                Ingredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                Ingredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
            ]
        ),
        Recipe(name: "Melanzana", rating: 3.0, imageUrl: "melanzana", time: 20, calories: 367, servings: 4, steps: [
            Step(name: "Prepare tatatata", desc: "", time: 0, ingredients: []),
            Step(name: "Cook the sauce", desc: "Let it simmer for 3 mintues", time: 4, ingredients: [
                Ingredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                Ingredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                Ingredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
                ]),
            Step(name: "Let rest for 4 minutes", desc: "", time: 4, ingredients: [])
            ], ingredients: [
                Ingredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                Ingredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                Ingredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMargin()
        ratingView.settings.updateOnTouch = false
        initView()
    }
    
    func initView() {
        ratingView.rating = Double(recipe.rating)
        recipeNameLabel.text = recipe.name
        ingredientsValueLabel.text = String(recipe.ingredients.count)
        caloriesValueLabel.text = String(recipe.calories)
        servingsValueLabel.text = String(recipe.servings)
        timeValueLabel.text = String(recipe.time)
        recipeCoverIV.image = UIImage(named: recipe.imageUrl)
        
        ingredientsTableViewConstraint.constant = CGFloat(44 * recipe.ingredients.count)
        //steps TableView
        tableViewHeightConstraint.constant = CGFloat(44 * recipe.steps.count)
    }
    
    func initMargin() {
        let margin = contentView.frame.width * 0.07
        
        //Recipe Name Label
        contentView.addConstraint(NSLayoutConstraint(item: recipeNameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin))
        //Recipe Rating View
        contentView.addConstraint(NSLayoutConstraint(item: ratingView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin))
        
        //Ingredient Stack View
        contentView.addConstraint(NSLayoutConstraint(item: ingredientsStack, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin/1.5))
        
        //Serving Stack View
        contentView.addConstraint(NSLayoutConstraint(item: servingsStack, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -margin/1.5))
        
        //Step Label
        contentView.addConstraint(NSLayoutConstraint(item: stepsLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin * 1.5))
        
        //Ingredients Label
        contentView.addConstraint(NSLayoutConstraint(item: ingredientsLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin * 1.5))
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == stepsTableView {
            return recipe.steps.count
        }
        else{
            return recipe.ingredients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == stepsTableView){
            let step = recipe.steps[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell")
            let contentView = cell?.viewWithTag(0)
            let margin = contentView!.frame.width * 0.15
            let nameLabel = contentView?.viewWithTag(1) as! UILabel
            contentView!.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin))
            nameLabel.text = step.name
            return cell!
        }else{
            let ingredient = recipe.ingredients[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell")
            let contentView = cell?.viewWithTag(0)
            let margin = contentView!.frame.width * 0.15
            let button = contentView?.viewWithTag(1) as! UIButton
            button.restorationIdentifier = String(ingredient.id)
            let nameLabel = contentView?.viewWithTag(2) as! UILabel
            contentView!.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin))
            contentView!.addConstraint(NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin*0.5))
            nameLabel.text = ingredient.name
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let similarRecipe = similarRecipes[indexPath.row]
        let cell = similarRecipesCollectionView.dequeueReusableCell(withReuseIdentifier: "similarRecipe", for: indexPath)
        let contentView = cell.viewWithTag(0)
        let image = contentView?.viewWithTag(1) as! UIImageView
        let rating = contentView?.viewWithTag(2) as! CosmosView
        let nameLabel = contentView?.viewWithTag(3) as! UILabel
        
        rating.settings.updateOnTouch = false
        rating.rating = Double(similarRecipe.rating)
        nameLabel.text = similarRecipe.name
        image.image = UIImage(named: similarRecipe.imageUrl)
        return cell
    }
    
    @IBAction func addIngredientClicked(_ sender: Any) {
        let button = sender as! UIButton
        let rowNumber = Int(button.restorationIdentifier!)
        print(rowNumber)
    }

    @IBAction func addAllIngredients(_ sender: Any) {
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
