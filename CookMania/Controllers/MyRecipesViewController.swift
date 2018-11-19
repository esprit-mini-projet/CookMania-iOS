//
//  MyRecipesViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/19/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class MyRecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var myRecipesTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dateFormatter = DateFormatter()
    var recipes: [Recipe] = []
    var myRecipeViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        UserService.getInstance().getUsersRecipes(user: appDelegate.user!, completionHandler: { recipes in
            self.recipes = recipes
            self.myRecipesTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myRecipeCell")
        let contentView = cell?.viewWithTag(0)
        let recipeCoverImageView = contentView?.viewWithTag(1) as! UIImageView
        let recipeNameLabel = contentView?.viewWithTag(2) as! UILabel
        let recipeDateLabel = contentView?.viewWithTag(3) as! UILabel
        let recipeFavoriteLabel = contentView?.viewWithTag(4) as! UILabel
        let recipeViewsLabel = contentView?.viewWithTag(5) as! UILabel
        let recipeRatingLabel = contentView?.viewWithTag(6) as! UILabel
        
        let recipe = self.recipes[indexPath.item]
        
        
        recipeCoverImageView.af_setImage(withURL: URL(string: recipe.imageUrl!)!)
        recipeNameLabel.text = recipe.name!
        recipeDateLabel.text = dateFormatter.string(from: Date())
        recipeViewsLabel.text = "100"
        recipeRatingLabel.text = "3.5"
        recipeFavoriteLabel.text = "20"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
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
