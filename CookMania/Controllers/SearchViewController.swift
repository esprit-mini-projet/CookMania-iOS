//
//  SearchViewController.swift
//  CookMania
//
//  Created by Elyes on 11/7/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var resultCV: UICollectionView!
    @IBOutlet weak var resultCount: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    
    var filter = Filter()
    var result = [SearchResult]()
    var sortByRating = true

    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = resultCV?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe", for: indexPath)
        let photo = cell.viewWithTag(1) as! UIImageView
        photo.layer.cornerRadius = 8
        photo.layer.masksToBounds = true
        photo.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + (result[indexPath.item].recipe?.imageUrl)!)!)
        let name = cell.viewWithTag(2) as! UILabel
        name.text = result[indexPath.item].recipe?.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RecipeService.getInstance().getRecipe(recipeId: (result[indexPath.item].recipe?.id)!) { (recipe) in
            self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilter"{
            let dest = segue.destination as! SearchFilterViewController
            dest.filter = filter
        } else if segue.identifier == "toRecipeDetails"{
            let dest = segue.destination as! RecipeDetailsViewController
            dest.recipe = (sender as! Recipe)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if filter.isChanged{
            performSearch()
        }
        print("calories:", filter.calories)
        print("servingsMin:", filter.minServings)
        print("servingsMax:", filter.maxServings)
        for label in filter.labels{
            print(label)
        }
    }
    
    func performSearch(){
        RecipeService.getInstance().search(filter: filter) { (result) in
            let sorted = self.performSorting(array: result)
            self.result.removeAll()
            self.result += sorted
            self.resultCV.reloadData()
            self.resultCount.text = String("\(sorted.count) results found.")
            self.filter.isChanged = false
            print("======")
            for sr in sorted{
                print("rating:", sr.recipe!.rating!, "calories:", sr.recipe!.calories!)
            }
        }
    }
    
    func performSorting(array: [SearchResult]) -> [SearchResult]{
        return array.sorted(by: { (r1, r2) -> Bool in
            if sortByRating{
                return r1.recipe!.rating! >= r2.recipe!.rating!
            }else{
                return r1.recipe!.calories! <= r2.recipe!.calories!
            }
        })
    }
    
    @IBAction func searchValueChanged(_ sender: UITextField) {
        print("search value:", sender.text)
        filter.name = sender.text ?? ""
        performSearch()
    }
    
    @IBAction func reset(_ sender: Any) {
        filter = Filter()
        searchBar.text = nil
        performSearch()
    }
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        sortByRating = sender.selectedSegmentIndex == 0 ? true : false
        let sorted = performSorting(array: result)
        result.removeAll()
        result += sorted
        resultCV.reloadData()
        print("======")
        for sr in sorted{
            print("rating:", sr.recipe!.rating!, "calories:", sr.recipe!.calories!)
        }
    }
}

extension SearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, ratioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageRatio = CGFloat(result[indexPath.item].imageHeight! / result[indexPath.item].imageWidth!)
        let textRatio = CGFloat((5 + 38.5) / result[indexPath.item].imageWidth!)
        return (imageRatio >= 0.8 ? imageRatio : 0.8) + textRatio
    }
}
