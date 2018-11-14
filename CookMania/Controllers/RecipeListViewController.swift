//
//  RecipeListViewController.swift
//  CookMania
//
//  Created by Elyes on 11/4/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class RecipeListViewController: UIViewController, UITableViewDataSource {
    
    var urlEndPoint: String? = nil
    var recipeList = [Recipe]()
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recipe")
        let imageView = cell?.viewWithTag(1) as! UIImageView
        let nameLabel = cell?.viewWithTag(2) as! UILabel
        imageView.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + recipeList[indexPath.row].imageUrl!)!)
        nameLabel.text = recipeList[indexPath.row].name
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func fetchData(){
        Alamofire.request(urlEndPoint!).responseString(completionHandler: { (response: DataResponse<String>) in
            self.recipeList = Mapper<Recipe>().mapArray(JSONString: response.result.value!)!
            self.recipeTableView.reloadData()
        })
    }
}
