//
//  HomeViewController.swift
//  CookMania
//
//  Created by Elyes on 11/3/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource {
    
    let popularRecipes = [
        Recipe(name: "Italian Chicken Cacciatore", image: "cacciatore"),
        Recipe(name: "Spaghetti Cacio e Pepe", image: "spaghetti"),
        Recipe(name: "Easy Caponata", image: "caponata"),
        Recipe(name: "Melanzana alla Parmigiana", image: "melanzana"),
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = UIImage.init(named: popularRecipes[indexPath.row].image!)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

    @IBAction func morePopular(_ sender: Any) {
        performSegue(withIdentifier: "toRecipeList", sender: popularRecipes)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toRecipeList":
            let recipeList = sender as! [Recipe]
            let destinationController = segue.destination as! RecipeListViewController
            destinationController.recipeList = recipeList
        default:
            print()
        }
    }
}
