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
        let persistance = appDelegate.persistentContainer
        let context = persistance.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "userId == %@", ((profileViewController?.user)!.id)!)
        do {
            let results = try context.fetch(request)
            for result in results {
                let recipeId = result.value(forKey: "recipeId") as! Int
            }
            //Need to be recplaced with getting recipe based on returned id
            UserService.getInstance().getUsersRecipes(user: (profileViewController?.user)!, completionHandler: { recipes in
                self.recipes = recipes
                self.favoriteTableView.reloadData()
            })
        } catch  {
            print("error")
        }
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
        recipeViewsLabel.text = "100"
        recipeRatingLabel.text = "3.5"
        recipeFavoriteLabel.text = "20"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(profileViewController?.user?.id == appDelegate.user!.id){
            if editingStyle == .delete{
                
            }
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
