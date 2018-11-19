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
    var recipes: [Recipe] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let label = contentView?.viewWithTag(1) as! UILabel
        
        let recipe = self.recipes[indexPath.item]
        
        label.text = recipe.name!
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
