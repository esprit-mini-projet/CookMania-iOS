//
//  AddRecipeViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Gallery

class AddRecipeContainerViewController: UIViewController, UICollectionViewDataSource, UITextViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, GalleryControllerDelegate{
    
    let blue = UIColor(red: 71/255, green: 121/255, blue: 152/255, alpha: 1.0)
    let white = UIColor.white
    var labelColor: CGColor?
    let descriptionPlaceHolder = "Description..."
    let labels = [
        "Healthy",
        "Cheap",
        "Easy",
        "Fast",
        "Vegetarian",
        "Breakfast",
        "Dinner",
        "Date Night",
        "Kids Friendly",
        "Takes Time"]
    
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
        var size = CGSize(width: 78, height: 50)
        print(label)
        print(label.count)
        if label.count > 6{
            size = CGSize(width: 125, height: 50)
        }
        return size
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
        
        descText.text = descriptionPlaceHolder
        descText.textColor = UIColor.lightGray
        descText.layer.borderColor = UIColor.lightGray.cgColor
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
            showAlert()
            return nil
        }
        guard let title = titleText.text, !title.isEmpty else{
            showAlert()
            return nil
        }
        guard let servings = servingsText.text, !servings.isEmpty, Int(servings)! > 0 else{
            showAlert()
            return nil
        }
        guard let calories = caloriesText.text, !calories.isEmpty, Int(calories)! > 0 else{
            showAlert()
            return nil
        }
        guard let time = timeText.text, !time.isEmpty, Int(time)! > 0 else{
            showAlert()
            return nil
        }
        guard let desc = descText.text, !desc.isEmpty else{
            showAlert()
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
    
    func showAlert(){
        let alert = UIAlertController(title: "Information Missing", message: "Make sure to add all necessary information.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionPlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
}
