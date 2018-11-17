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

class HomeViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var topRatedCV: UICollectionView!
    @IBOutlet weak var fastCheapCV: UICollectionView!
    @IBOutlet weak var healthyCV: UICollectionView!
    @IBOutlet weak var kidsCV: UICollectionView!
    @IBOutlet weak var recentCV: UICollectionView!
    
    var topRated = [Recipe]()
    var fastCheap = [Recipe]()
    var healthy = [Recipe]()
    var kids = [Recipe]()
    var recent = [Recipe]()
    
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.recentCV{
            print("RecentCV")
            return 20
        }
        return topRated.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        if collectionView == self.recentCV{
            return cell
        }
        let nameLabel = cell.viewWithTag(2) as! UILabel
        if collectionView != self.topRatedCV{
            print("Not Top Rated")
            return cell
        }
        imageView.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + topRated[indexPath.row].imageUrl!)!)
        nameLabel.text = topRated[indexPath.row].name!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.size.width * 0.4
        var height = collectionView.frame.size.height
        if collectionView == self.recentCV{
            width = collectionView.frame.size.width * 0.49
            height = width
        }
        return CGSize(width: width, height: height)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTopRated()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }

    @IBAction func morePopular(_ sender: Any) {
        performSegue(withIdentifier: "toRecipeList", sender: Constants.URL.topRatedRecipes)
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
