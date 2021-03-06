//
//  AddRecipeViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Gallery

class AddRecipeContainerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, GalleryControllerDelegate{
    
    let blue = UIColor(red: 71/255, green: 121/255, blue: 152/255, alpha: 1.0)
    let white = UIColor.white
    var labelColor: CGColor?
    let descriptionPlaceHolder = "Description..."
    var labels = [String]()
    
    var recipe: Recipe?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var servingsText: UITextField!
    @IBOutlet weak var caloriesText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var labelsCV: UICollectionView!
    
    var imageChanged = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let label = labels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Label", for: indexPath)
        let button = cell.viewWithTag(1) as! UIButton
        button.setTitle(label, for: .normal)
        button.addTarget(self, action: #selector(AddRecipeContainerViewController.highlight), for: UIControl.Event.touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        labelColor = button.titleColor(for: .normal)?.cgColor.copy()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = labels[indexPath.item]
        let width = 78
        let height = 50
        var bonus = 0
        if label.count > 6{
            bonus = (label.count - 6) * 8
        }
        return CGSize(width: width + bonus, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
    }
    
    @objc func highlight(_ sender: UIButton){
        if sender.backgroundColor == white{
            sender.backgroundColor = blue
            sender.setTitleColor(white, for: .normal)
            sender.layer.borderWidth = 0
            recipe?.labels?.append(sender.title(for: .normal)!)
            return
        }
        sender.backgroundColor = white
        sender.setTitleColor(UIColor(cgColor: labelColor!), for: .normal)
        sender.layer.borderWidth = 1
        for (i, label) in (recipe?.labels?.enumerated())!{
            if label == sender.title(for: .normal)! {
                recipe?.labels?.remove(at: i)
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipe = Recipe()
        recipe?.labels = [String]()
        
        descText.layer.borderColor = UIColor.lightGray.cgColor
        
        RecipeService.getInstance().getLabelsFlat { (labels) in
            self.labels += labels
            self.labelsCV.reloadData()
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        Config.tabsToShow = [.cameraTab, .imageTab]
        Config.Camera.imageLimit = 1
        
        let gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        images[0].resolve(completion: { image in
            self.imageView.image = image!
            self.imageChanged = true
        })
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func checkRecipe() -> Recipe?{
        guard imageChanged else{
            showAlert(title: "Image Missing", message: "Make sure to add an image for your recipe.")
            return nil
        }
        guard let title = titleText.text, !title.isEmpty else{
            showAlert(title: "Title Missing", message: "Make sure to add a title for the recipe.")
            return nil
        }
        guard let servings = servingsText.text, !servings.isEmpty, Int(servings)! > 0 else{
            showAlert(title: "Number of servings Missing", message: "Make sure to add the number of servings.")
            return nil
        }
        guard let calories = caloriesText.text, !calories.isEmpty, Int(calories)! > 0 else{
            showAlert(title: "Calories Missing", message: "Make sure to add the recipe calories.")
            return nil
        }
        guard let time = timeText.text, !time.isEmpty, Int(time)! > 0 else{
            showAlert(title: "Time Missing", message: "Make sure to add the recipe duration.")
            return nil
        }
        guard let desc = descText.text, !desc.isEmpty else{
            showAlert(title: "Description Missing", message: "Make sure to add a description for your recipe.")
            return nil
        }
        guard !recipe!.labels!.isEmpty else{
            showAlert(title: "Labels Missing", message: "Make sure to select at least one label.")
            return nil
        }
        recipe!.name = title
        recipe!.description = desc
        recipe!.servings = Int(servings)
        recipe!.calories = Int(calories)
        recipe!.time = Int(time)
        recipe!.steps = [Step]()
        return recipe
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert,animated: true,completion: nil)
    }
}
