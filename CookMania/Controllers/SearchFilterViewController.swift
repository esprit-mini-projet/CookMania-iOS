//
//  SearchResultViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import TTRangeSlider

class SearchFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var caloriesSegCont: UISegmentedControl!
    @IBOutlet weak var servingsSlider: TTRangeSlider!
    @IBOutlet weak var categoriesTV: UITableView!
    
    var filter: Filter?
    
    let sortItems = ["Rating", "Time"]
    let calories = ["All", "Low", "Normal", "Rich"]
    
    var categories = [[Any]]()
    
    let blue = UIColor(red: 71/255, green: 121/255, blue: 152/255, alpha: 1.0)
    let lightGray = UIColor.lightGray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecipeService.getInstance().getLabels { (labels) in
            self.categories = labels
            self.categoriesTV.reloadData()
            
        }
        for (i, value) in calories.enumerated(){
            if value == filter?.calories{
                caloriesSegCont.selectedSegmentIndex = i
                break
            }
        }
        servingsSlider.selectedMinimum = Float((filter?.minServings)!)
        servingsSlider.selectedMaximum = Float((filter?.maxServings)!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.restorationIdentifier {
        case "sort":
            return sortItems.count
        case "category":
            return categories.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.restorationIdentifier == "sort"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortItem")
            let contentView = cell?.viewWithTag(0)
            let label = contentView?.viewWithTag(1) as! UILabel
            label.text = sortItems[indexPath.row]
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Category")
            let contentView = cell?.viewWithTag(0)
            let category = contentView?.viewWithTag(1) as! UILabel
            let collectionView = contentView?.viewWithTag(2) as! UICollectionView
            let categoryText = categories[indexPath.item][0] as! String
            category.text = categoryText
            collectionView.restorationIdentifier = String(indexPath.item)
            collectionView.dataSource = self
            collectionView.delegate = self
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
            tableView.deselectRow(at: oldIndex, animated: true)
            if oldIndex != indexPath{
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        print("selected:", indexPath.row)
        
        return indexPath
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (categories[Int(collectionView.restorationIdentifier!)!][1] as! [String]).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Category", for: indexPath)
        let button = cell.viewWithTag(1) as! UIButton
        button.setTitleColor(lightGray, for: UIControl.State.normal)
        button.layer.cornerRadius = 14
        let labels = categories[Int(collectionView.restorationIdentifier!)!][1] as! [String]
        button.setTitle(labels[indexPath.item], for: UIControl.State.normal)
        initCategoryButtonFromFilter(button: button)
        return cell
    }
    
    @IBAction func highlightCategory(_ sender: UIButton) {
        let title = sender.title(for: UIControl.State.normal)!
        if sender.titleColor(for: UIControl.State.normal) == lightGray{
            sender.setTitleColor(blue, for: .normal)
            sender.layer.borderWidth = 1
            sender.layer.borderColor = blue.cgColor
            filter!.labels.append(title)
            return
        }
        sender.setTitleColor(lightGray, for: .normal)
        sender.layer.borderWidth = 0
        for (i, label) in (filter?.labels.enumerated())!{
            if label == title{
                filter!.labels.remove(at: i)
                break
            }
        }
    }
    
    func initCategoryButtonFromFilter(button: UIButton){
        if (filter?.labels.contains(button.title(for: UIControl.State.normal)!))!{
            button.setTitleColor(blue, for: .normal)
            button.layer.borderWidth = 1
            button.layer.borderColor = blue.cgColor
        }else{
            button.setTitleColor(lightGray, for: .normal)
            button.layer.borderWidth = 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labels = categories[Int(collectionView.restorationIdentifier!)!][1] as! [String]
        let label = labels[indexPath.item]
        let width = 78
        let height = 50
        var bonus = 0
        if label.count > 6{
            bonus = (label.count - 6) * 8
        }
        return CGSize(width: width + bonus, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    @IBAction func apply(_ sender: Any) {
        filter!.calories = caloriesSegCont.titleForSegment(at: caloriesSegCont.selectedSegmentIndex)!
        filter?.minServings = Int(servingsSlider.selectedMinimum)
        filter?.maxServings = Int(servingsSlider.selectedMaximum)
        filter?.isChanged = true
        navigationController?.popViewController(animated: true)
    }
    
}
