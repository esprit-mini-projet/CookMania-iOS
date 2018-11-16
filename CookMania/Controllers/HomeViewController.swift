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

class HomeViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource {
    
    var topRated = [Recipe]()
    
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topRated.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + topRated[indexPath.row].imageUrl!)!)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopRated()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

    @IBAction func morePopular(_ sender: Any) {
        //performSegue(withIdentifier: "toRecipeList", sender: Constants.URL.topRatedRecipes)
        performSegue(withIdentifier: "toRecipeDetails", sender: Constants.URL.topRatedRecipes)
    }
    
    @IBAction func addRecipe(_ sender: Any) {
        performSegue(withIdentifier: "toAddRecipe", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toRecipeList":
            let destinationController = segue.destination as! RecipeListViewController
            destinationController.urlEndPoint = sender as? String
        default:
            print()
        }
    }
    
    func fetchTopRated(){
        Alamofire.request(Constants.URL.topRatedRecipes).responseString(completionHandler: { (response: DataResponse<String>) in
            self.topRated = Mapper<Recipe>().mapArray(JSONString: response.result.value!)!
            self.topRatedCollectionView.reloadData()
        })
    }
}
