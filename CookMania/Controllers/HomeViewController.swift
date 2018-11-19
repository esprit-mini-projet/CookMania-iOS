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

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var topRatedCV: UICollectionView!
    @IBOutlet weak var fastCheapCV: UICollectionView!
    @IBOutlet weak var healthyCV: UICollectionView!
    @IBOutlet weak var kidsCV: UICollectionView!
    
    var topRated = [Recipe]()
    var fastCheap = [Recipe]()
    var healthy = [Recipe]()
    var kids = [Recipe]()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topRated.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        let url = URL(string: Constants.URL.imagesFolder + topRated[indexPath.row].imageUrl!)!
        imageView.af_setImage(withURL: url)
        let nameLabel = cell.viewWithTag(2) as! UILabel
        nameLabel.text = topRated[indexPath.row].name!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width * 0.4
        let height = collectionView.frame.size.height
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
            self.topRatedCV.reloadData()
            self.fastCheapCV.reloadData()
            self.kidsCV.reloadData()
            self.healthyCV.reloadData()
        })
    }
}
