//
//  SearchViewController.swift
//  CookMania
//
//  Created by Elyes on 11/7/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var resultCV: UICollectionView!
    
    let filter = Filter()
    
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
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Recipe", for: indexPath)
        let photo = cell.viewWithTag(1) as! UIImageView
        photo.image = images[indexPath.item]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilter"{
            let dest = segue.destination as! SearchFilterViewController
            dest.filter = filter
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("calories:", filter.calories)
        print("servingsMin:", filter.minServings)
        print("servingsMax:", filter.maxServings)
        for label in filter.labels{
            print(label)
        }
    }

}

extension SearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, ratioForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return images[indexPath.item]!.size.height / images[indexPath.item]!.size.width
    }
}
