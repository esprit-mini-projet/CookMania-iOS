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
    
    @IBOutlet weak var favoriteRecipesTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favoriteRecipes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let persistance = appDelegate.persistentContainer
        let context = persistance.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "userId == %@", (appDelegate.user?.id)!)
        do {
            let result = try context.fetch(request)
            favoriteRecipes = result
        } catch  {
            print("error")
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteRecipesTableView.dequeueReusableCell(withIdentifier: "favoriteRecipeViewCell")
        let contentView = cell?.viewWithTag(0)
        let nameLabel = contentView?.viewWithTag(1) as! UILabel
        
        nameLabel.text = String(favoriteRecipes[indexPath.item].value(forKey: "recipeId") as! Int)
        return cell!
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
