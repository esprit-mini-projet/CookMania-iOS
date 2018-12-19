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
        fetchRecipes()
        addTapActionToSuggestions()
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
            let dest = segue.destination as! RecipeListViewController
            dest.urlEndPoint = sender as? String
        case "toRecipeDetails":
            let dest = segue.destination as! RecipeDetailsViewController
            dest.recipe = (sender as! Recipe)
        default:
            return
        }
    }
    
}
