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
    @IBOutlet weak var searchBar: UISearchBar!
    
    let filter = Filter()
    var result = [SearchResult]()
    
    var images = [
        UIImage(named: "d1"),
        UIImage(named: "d5"),
        UIImage(named: "d3"),
        UIImage(named: "d4"),
        UIImage(named: "d2"),
        UIImage(named: "d6")
    ]

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
        photo.af_setImage(withURL: URL(string: Constants.URL.imagesFolder + (result[indexPath.item].recipe?.imageUrl)!)!)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilter"{
            let dest = segue.destination as! SearchFilterViewController
            dest.filter = filter
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
            self.result.removeAll()
            self.result += result
            self.resultCV.reloadData()
            self.resultCount.text = String("\(result.count) results found.")
            self.filter.isChanged = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter.name = searchText
        performSearch()
    }
}

extension SearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, ratioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return CGFloat(result[indexPath.item].imageHeight! / result[indexPath.item].imageWidth!)
    }
}
