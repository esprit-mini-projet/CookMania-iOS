//
//  RecipeDetailsViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/7/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Cosmos
import CoreData

class RecipeDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var ratingBarView: CosmosView!
    @IBOutlet weak var nameLabelView: UILabel!
    @IBOutlet weak var ingredientsNumberLabelView: UILabel!
    @IBOutlet weak var caloriesLabelView: UILabel!
    @IBOutlet weak var servingsLabelView: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var ingredientsView: UIView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    var user:User?
    
    let ratingValue = 3.6
    let recipeID = "API_12345"
    let recipeName = "Test Recipe"
    let numIngredients = 10
    let caloriesValue = 360
    let numServings = 4
    let recipeImageName = "recipe_ex2"
    
    let ingredients = ["Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion","Tomates", "Onion"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        initRecipeImageView()
        initShadowView()
        initRatingBarView()
        initLabels()
    }
    
    func initLabels(){
        nameLabelView.text = recipeName
        view.bringSubviewToFront(nameLabelView)
        
        ingredientsNumberLabelView.text = String(numIngredients)
        view.bringSubviewToFront(ingredientsNumberLabelView)
        view.bringSubviewToFront(ingredientsLabel)
        
        caloriesLabelView.text = String(caloriesValue)
        view.bringSubviewToFront(caloriesLabelView)
        view.bringSubviewToFront(caloriesLabel)
        
        servingsLabelView.text = String(numServings)
        view.bringSubviewToFront(servingsLabelView)
        view.bringSubviewToFront(servingsLabel)
    }
    
    func initRecipeImageView() {
        recipeImageView.clipsToBounds = true;
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.image = UIImage(named: recipeImageName)
    }
    
    func initRatingBarView() {
        ratingBarView.settings.updateOnTouch = false
        ratingBarView.settings.fillMode = .precise
        ratingBarView.settings.emptyBorderColor = UIColor.clear
        ratingBarView.rating = ratingValue
        view.bringSubviewToFront(ratingBarView)
    }
    
    func initShadowView(){
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y:1.0)
        let whiteColor = UIColor.white
        gradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(1.0), whiteColor.withAlphaComponent(1.0).cgColor]
        gradient.locations = [NSNumber(value: 0.0),NSNumber(value: 0.2),NSNumber(value: 1.0)]
        gradient.frame = shadowView.bounds
        shadowView.layer.mask = gradient
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell")
        let contentView = cell?.viewWithTag(0)
        let btn = contentView?.viewWithTag(1) as! UIButton
        let nomLabel = contentView?.viewWithTag(2) as! UILabel
        nomLabel.text = ingredients[indexPath.row]
        return cell!
    }

    @IBAction func addToFavorite(_ sender: Any) {
        
        printCoreData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistantContainer = appDelegate.persistentContainer
        let managedContext = persistantContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
        request.predicate = NSPredicate(format: "userId == %@ AND recipeId == %@", (self.user?.id)!, recipeID)
        do{
            let result = try managedContext.fetch(request)
            print(result)
            if(result.count == 0){
                let recipeDesc = NSEntityDescription.entity(forEntityName: "FavoriteRecipe", in: managedContext)
                let recipe = NSManagedObject(entity: recipeDesc!, insertInto: managedContext)
                recipe.setValue(user?.id, forKey: "userId")
                recipe.setValue(recipeID, forKey: "recipeId")
                recipe.setValue(Date(), forKey: "date")
                
                do{
                    try managedContext.save()
                    print("saved")
                } catch {
                    print("error")
                }
            }else{
                let alert = UIAlertController(title: "Alert", message: "Recipe already added to favories", preferredStyle: .alert)
                let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        }catch{
            print("Error")
        }
    }
    
    func printCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistance = appDelegate.persistentContainer
        let context = persistance.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "FavoriteRecipe")
        do {
            let result = try context.fetch(request)
            print("**********************************************************")
            print(result)
        } catch  {
            print("error")
        }
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
