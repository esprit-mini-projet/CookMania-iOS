//
//  HomeViewController.swift
//  CookMania
//
//  Created by Elyes on 11/3/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import ObjectMapper
import CoreStore

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var topRatedCV: UICollectionView!
    @IBOutlet weak var healthyCV: UICollectionView!
    @IBOutlet weak var cheapCV: UICollectionView!
    
    @IBOutlet weak var suggestionsTitle: UILabel!
    @IBOutlet weak var suggestion1: SuggestionImageView!
    @IBOutlet weak var suggestion2: SuggestionImageView!
    @IBOutlet weak var suggestion3: SuggestionImageView!
    @IBOutlet weak var suggestion4: SuggestionImageView!
    
    var topRated = [Recipe]()
    var cheap = [Recipe]()
    var healthy = [Recipe]()
    var suggestions = [Recipe]()
    
    override func viewDidAppear(_ animated: Bool) {
        let tabController = self.navigationController?.parent as! MainTabLayoutViewController
        
        if tabController.notification != nil && tabController.notification!.notificationId != nil{
            let notification = tabController.notification
            if notification!.notificationType == NotificationType.followingAddedRecipe{
                RecipeService.getInstance().getRecipe(recipeId: Int(notification!.notificationId)!, completionHandler: { recipe in
                    tabController.notification = nil
                    self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
                })
            }else if notification!.notificationType == NotificationType.follower{
                UserService.getInstance().getUser(id: notification!.notificationId, completionHandler: { user in
                    tabController.notification = nil
                    self.performSegue(withIdentifier: "toProfile", sender: user)
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.topRatedCV:
            return topRated.count
        case self.healthyCV:
            return healthy.count
        case self.cheapCV:
            return cheap.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        let nameLabel = cell.viewWithTag(2) as! UILabel
        var url: URL
        var name: String
        switch collectionView {
        case self.topRatedCV:
            url = URL(string: Constants.URL.imagesFolder + topRated[indexPath.row].imageUrl!)!
            name = topRated[indexPath.row].name!
        case self.healthyCV:
            url = URL(string: Constants.URL.imagesFolder + healthy[indexPath.row].imageUrl!)!
            name = healthy[indexPath.row].name!
        case self.cheapCV:
            url = URL(string: Constants.URL.imagesFolder + cheap[indexPath.row].imageUrl!)!
            name = cheap[indexPath.row].name!
        default:
            return cell
        }
        imageView.af_setImage(withURL: url)
        nameLabel.text = name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width * 0.4
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var recipes: [Recipe]
        if collectionView == topRatedCV{
            recipes = topRated
        }else if collectionView == healthyCV{
            recipes = healthy
        }else{
            recipes = cheap
        }
        let recipe = recipes[indexPath.item]
        RecipeService.getInstance().getRecipe(recipeId: recipe.id!, completionHandler: { recipe in
            self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeCoreStore()
        fetchRecipes()
        addTapActionToSuggestions()
        //testShoppinglist()
    }
    
    func initializeCoreStore(){
        let stack = DataStack(xcodeModelName: "CookMania")
        CoreStore.defaultStack = stack
        do {
            try CoreStore.addStorageAndWait()
        }
        catch {
            print("error adding storage to CoreStore")
        }
    }
    
    func addTapActionToSuggestions(){
        var singleTap = UITapGestureRecognizer(target: self, action: #selector(goToRecipe1(_:)))
        self.suggestion1.isUserInteractionEnabled = true
        self.suggestion1.addGestureRecognizer(singleTap)
        
        singleTap = UITapGestureRecognizer(target: self, action: #selector(goToRecipe2(_:)))
        self.suggestion2.isUserInteractionEnabled = true
        self.suggestion2.addGestureRecognizer(singleTap)
        
        singleTap = UITapGestureRecognizer(target: self, action: #selector(goToRecipe3(_:)))
        self.suggestion3.isUserInteractionEnabled = true
        self.suggestion3.addGestureRecognizer(singleTap)
        
        singleTap = UITapGestureRecognizer(target: self, action: #selector(goToRecipe4(_:)))
        self.suggestion4.isUserInteractionEnabled = true
        self.suggestion4.addGestureRecognizer(singleTap)
    }
    
    @objc func goToRecipe1(_ sender: SuggestionImageView) {
        RecipeService.getInstance().getRecipe(recipeId: suggestion1.recipe!.id!, completionHandler: { recipe in
            self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
        })
    }
    @objc func goToRecipe2(_ sender: SuggestionImageView) {
        RecipeService.getInstance().getRecipe(recipeId: suggestion2.recipe!.id!, completionHandler: { recipe in
            self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
        })
    }
    @objc func goToRecipe3(_ sender: SuggestionImageView) {
        RecipeService.getInstance().getRecipe(recipeId: suggestion3.recipe!.id!, completionHandler: { recipe in
            self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
        })
    }
    @objc func goToRecipe4(_ sender: SuggestionImageView) {
        RecipeService.getInstance().getRecipe(recipeId: suggestion4.recipe!.id!, completionHandler: { recipe in
            self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
        })
    }
    
    func fetchRecipes(){
        RecipeService.getInstance().getRecipeSuggestions { (title: String, recipes: [Recipe]) in
            self.suggestions = recipes
            self.suggestionsTitle.text = title
            
            self.suggestion1.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + recipes[0].imageUrl!)!)
            self.suggestion1.recipe = recipes[0]
            
            self.suggestion2.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + recipes[1].imageUrl!)!)
            self.suggestion2.recipe = recipes[1]
            
            self.suggestion3.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + recipes[2].imageUrl!)!)
            self.suggestion3.recipe = recipes[2]
            
            self.suggestion4.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + recipes[3].imageUrl!)!)
            self.suggestion4.recipe = recipes[3]
        }
        RecipeService.getInstance().getTopRecipes { (recipes: [Recipe]) in
            self.topRated = recipes
            self.topRatedCV.reloadData()
        }
        RecipeService.getInstance().getRecipesByLabel(label: "Healthy") { (recipes: [Recipe]) in
            self.healthy = recipes
            self.healthyCV.reloadData()
        }
        RecipeService.getInstance().getRecipesByLabel(label: "Cheap") { (recipes: [Recipe]) in
            self.cheap = recipes
            self.cheapCV.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

    @IBAction func morePopular(_ sender: Any) {
        performSegue(withIdentifier: "toRecipeList", sender: Constants.URL.topRatedRecipes)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toRecipeList":
            let destinationController = segue.destination as! RecipeListViewController
            destinationController.urlEndPoint = sender as? String
            break
        case "toRecipeDetails":
            let destinationController = segue.destination as! RecipeDetailsViewController
            destinationController.recipe = sender as? Recipe
            break
        case "toProfile":
            let destinationController = segue.destination as! OthersProfileViewController
            destinationController.user = sender as? User
            break;
        default:
            return
        }
    }
    
    func testShoppinglist(){
        /*do{
            try CoreStore.perform(synchronous: { (transaction) -> Int? in
                transaction.deleteAll(From<ShopIngredient>())
            }, waitForAllObservers: true)
        }catch{
            print("error deleting")
        }*/
        /*let ingredient = Ingredient()
        ingredient.id = 5
        ingredient.name = "sugar"
        ingredient.quantity = 20
        ingredient.unit = "g"
        let ingredient2 = Ingredient()
        ingredient2.id = 4
        ingredient2.name = "salt"
        ingredient2.quantity = 13
        ingredient2.unit = "ml"
        let ingredient3 = Ingredient()
        ingredient3.id = 1
        ingredient3.name = "water"
        ingredient3.quantity = 4
        ingredient3.unit = ""
        
        let step1 = Step()
        step1.ingredients = [Ingredient]()
        step1.ingredients?.append(ingredient)
        step1.ingredients?.append(ingredient2)
        
        let step2 = Step()
        step2.ingredients = [Ingredient]()
        step2.ingredients?.append(ingredient3)
        
        let recipe = Recipe()
        recipe.id = 4
        recipe.name = "pizza"
        recipe.imageUrl = "1.jpg"
        recipe.steps = [Step]()
        recipe.steps?.append(step1)
        recipe.steps?.append(step2)
        
        let recipe2 = Recipe()
        recipe2.id = 5
        recipe2.name = "spaghetti"
        recipe2.imageUrl = "2.jpg"
        recipe2.steps = [Step]()
        recipe2.steps?.append(step1)
        
        ShopRecipeDao.getInstance().add(recipe: recipe) { (success) in
            
        }
        ShopRecipeDao.getInstance().add(recipe: recipe2) { (success) in
            
        }*/
        
        /*ShopRecipeDao.getInstance().add(recipe: recipe) { (success) in
            let recipes = ShopRecipeDao.getInstance().getRecipes()
            /*for recipe in recipes{
                var string = "{id: \(recipe.id),\nname: \(recipe.name!),\ningredients:[\n"
                print(recipe.ingredients!.count)
                for ingr in recipe.ingredients!{
                    let ing = ingr as! ShopIngredient
                    string = string + "{id: \(ing.id),\nname: \(ing.name!),\nquantity: \(ing.quantity),\nunit: \(ing.unit)},\n"
                }
                print(string)
            }*/
            
            print("Recipe count: ", recipes.count)
            let ingredients = CoreStore.fetchAll(From<ShopIngredient>())
            print("Ingredients count: ", ingredients!.count)
            
            ShopIngredientDao.getInstance().add(ingredient: ingredient3, recipe: recipe, completionHandler: { (success) in
                print("Recipe count: ", recipes.count)
                let ingredients = CoreStore.fetchAll(From<ShopIngredient>())
                print("Ingredients count: ", ingredients!.count)
            })
         
        }*/
        /*ShopRecipeDao.getInstance().delete(recipeId: 4) {
            let recipes = ShopRecipeDao.getInstance().getRecipes()
            print("Recipe count: ", recipes.count)
            let ingredients = CoreStore.fetchAll(From<ShopIngredient>())
            print("Ingredients count: ", ingredients!.count)
        }*/
    }
    
}
