//
//  FavoritesViewController.swift
//  CookMania
//
//  Created by Elyes on 11/5/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var favoriteTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var recipes: [Recipe] = []
    let dateFormatter = DateFormatter()
    var profileViewController: ProfileViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd MMM, yyyy"
    }
    
    func updateTableView() {
        FavoriteHelper.getInstance().getFavoriteRecipes(userId: (profileViewController?.user?.id)!, completionHandler: { recTab in
            self.recipes = recTab
            self.favoriteTableView.reloadData()
        })
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myRecipeCell")
        let contentView = cell?.viewWithTag(0)
        let shadowView = contentView?.viewWithTag(1) as! UIView
        let cardView = contentView?.viewWithTag(2) as! UIView
        let recipeCoverImageView = cardView.viewWithTag(3) as! UIImageView
        let recipeNameLabel = cardView.viewWithTag(4) as! UILabel
        let recipeDateLabel = cardView.viewWithTag(5) as! UILabel
        let recipeFavoriteLabel = cardView.viewWithTag(6) as! UILabel
        let recipeViewsLabel = cardView.viewWithTag(7) as! UILabel
        let recipeRatingLabel = cardView.viewWithTag(8) as! UILabel
        
        let recipe = self.recipes[indexPath.item]
        
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        shadowView.layer.shadowOpacity = 0.7
        
        
        recipeCoverImageView.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + recipe.imageUrl!)!)
        recipeNameLabel.text = recipe.name!
        recipeDateLabel.text = dateFormatter.string(from: Date())
        recipeViewsLabel.text = String((recipe.views)!)
        recipeRatingLabel.text = String((recipe.rating)!)
        recipeFavoriteLabel.text = String((recipe.favorites)!)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(profileViewController?.user?.id == appDelegate.user!.id){
            let removeFavoriteAction = removeFavorite(at: indexPath)
            return UISwipeActionsConfiguration(actions: [removeFavoriteAction])
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    func removeFavorite(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            let recipe = self.recipes[indexPath.item]
            let alert = UIAlertController(title: "Confirmation", message: "Do you really want to remove this recipe from your favorite list?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                FavoriteHelper.getInstance().getFavorite(userId: (self.appDelegate.user?.id)!, recipeId: recipe.id!, successCompletionHandler: { favorite in
                    FavoriteHelper.getInstance().removeFavoriteRecipe(favorite: favorite!, successCompletionHandler: {
                        self.updateTableView()
                        self.profileViewController?.myRecipesViewController?.updateTableView()
                        let alertDisapperTimeInSeconds = 2.0
                        let alert = UIAlertController(title: nil, message: "Recipe removed from your favorite list.", preferredStyle: .actionSheet)
                        self.present(alert, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                            alert.dismiss(animated: true)
                        }
                    }, errorCompletionHandler: {
                        UIUtils.showErrorAlert(title: "Error", message: "An error has occured while removing revipe from your favorite list, please try again.", viewController: self)
                    })
                }, errorCompletionHandler: {
                    UIUtils.showErrorAlert(title: "Error", message: "An error has occured while removing revipe from your favorite list, please try again.", viewController: self)
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completion(true)
        }
        action.image = UIImage(named: "remove-favorite")
        action.backgroundColor = UIColor.init(rgb: 0xE32929)
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.item]
        RecipeService.getInstance().getRecipe(recipeId: recipe.id!, completionHandler: { rec in
            self.performSegue(withIdentifier: "toDetails", sender: rec)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let destination = segue.destination as! RecipeDetailsViewController
            let recipe = sender as! Recipe
            
            destination.recipe = recipe
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
