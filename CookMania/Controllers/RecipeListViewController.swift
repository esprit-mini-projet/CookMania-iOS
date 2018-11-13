//
//  RecipeListViewController.swift
//  CookMania
//
//  Created by Elyes on 11/4/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class RecipeListViewController: UIViewController, UITableViewDataSource {
    
    var recipeList = [Recipe]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recipe")
        let imageView = cell?.viewWithTag(1) as! UIImageView
        let nameLabel = cell?.viewWithTag(2) as! UILabel
        imageView.image = UIImage.init(named: recipeList[indexPath.row].image!)
        nameLabel.text = recipeList[indexPath.row].name
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
