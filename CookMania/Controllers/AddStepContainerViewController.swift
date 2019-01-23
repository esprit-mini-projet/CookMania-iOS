//
//  AddStepViewController.swift
//  CookMania
//
//  Created by Elyes on 11/28/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Gallery
import EasyTipView
import SwiftKeychainWrapper

class AddStepContainerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GalleryControllerDelegate, EasyTipViewDelegate {
    
    let SEEN_SWIPE_HINT_KEY = "ingredient_swipe_hint"
    let descriptionPlaceHolder = "Description..."
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeText: UITextField!
    
    var recipe: Recipe?
    var recipeImage: UIImage?
    var step: Step?
    var images: [UIImage?]?
    var imageChanged = false
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        KeychainWrapper.standard.set(true, forKey: SEEN_SWIPE_HINT_KEY)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return step!.ingredients!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //retrieving references
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ingredient")
        let contentView = cell?.viewWithTag(0)
        let quantity = contentView?.viewWithTag(1) as! ActionTextField
        let unit = contentView?.viewWithTag(2) as! ActionSegmentControl
        let name = contentView?.viewWithTag(3) as! ActionTextField
        
        //affecting values
        if let n = step!.ingredients![indexPath.row].quantity{
            quantity.text = String(n)
        }else{
            quantity.text = nil
        }
        if let u = step!.ingredients![indexPath.row].unit{
            for i in 0..<3{
                if u == unit.titleForSegment(at: i){
                    unit.selectedSegmentIndex = i
                }
            }
        }else{
            unit.selectedSegmentIndex = 0
        }
        name.text = step!.ingredients![indexPath.row].name
        
        //setting up listeners
        quantity.indexPath = indexPath
        quantity.addTarget(self, action: #selector(quantityDidChange(_:)), for: UIControl.Event.editingChanged)
        name.indexPath = indexPath
        name.addTarget(self, action: #selector(nameDidChange(_:)), for: UIControl.Event.editingChanged)
        unit.indexPath = indexPath
        unit.addTarget(self, action: #selector(unitDidChange(_:)), for: UIControl.Event.valueChanged)
        
        return cell!
    }
    
    @objc func quantityDidChange(_ sender: ActionTextField) {
        step!.ingredients![sender.indexPath!.row].quantity = Int(sender.text!)
    }
    @objc func nameDidChange(_ sender: ActionTextField) {
        step!.ingredients![sender.indexPath!.row].name = sender.text
    }
    @objc func unitDidChange(_ sender: ActionSegmentControl) {
        step!.ingredients![sender.indexPath!.row].unit = sender.titleForSegment(at: sender.selectedSegmentIndex)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            step!.ingredients!.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descText.layer.borderColor = UIColor.lightGray.cgColor
        
        step = Step()
        step?.ingredients = [Ingredient(), Ingredient(), Ingredient()]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !step!.ingredients!.isEmpty{
            if !(KeychainWrapper.standard.bool(forKey: SEEN_SWIPE_HINT_KEY) ?? false){
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
                EasyTipView(text: "You can swipe left to remove an ingredient. Tap to dismiss.", preferences: EasyTipView.globalPreferences, delegate: self).show(forView: cell!, withinSuperview: tableView)
            }
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
    
    @IBAction func addIngredient(_ sender: Any){
        step!.ingredients!.append(Ingredient())
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: step!.ingredients!.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func checkStep() -> Bool{
        guard let desc = descText.text, !desc.isEmpty else{
            showAlert(title: "Description Missing", message: "Make sure to write a description.")
            return false
        }
        for ingredient in step!.ingredients!{
            guard let name = ingredient.name, !name.isEmpty else{
                showAlert(title: "Ingredient name Missing", message: "Make sure to add all ingredient names.")
                return false
            }
            guard let quantity = ingredient.quantity, quantity > 0 else{
                showAlert(title: "Ingredient Quantity Missing", message: "Make sure to add all ingredient quantities.")
                return false
            }
            var first = true
            for ing in step!.ingredients!{
                if ing.name! == ingredient.name!{
                    if first{
                        first = false
                    }else{
                        showAlert(title: "Ingredient repeated", message: "Make sure to bundle the same ingredients together.")
                        return false
                    }
                }
            }
            if let _ = ingredient.unit {
                if ingredient.unit == "N/A"{
                    ingredient.unit = ""
                }
            }else{
                ingredient.unit = "g"
            }
        }
        step!.description = desc
        if let time = Int(timeText.text!){
            step!.time = time
        }else{
            step!.time = 0
        }
        recipe!.steps!.append(step!)
        if imageChanged {
            images?.append(imageView.image)
        }else {
            images?.append(nil)
        }
        return true
    }
    
    @IBAction func addStep(_ sender: Any){
        if checkStep(){
            performSegue(withIdentifier: "toAddStep", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddStep"{
            let dest = segue.destination as! AddStepViewController
            dest.recipe = recipe
            dest.recipeImage = recipeImage
            dest.images = images
        }else if segue.identifier == "toRecipeDetails"{
            let dest = segue.destination as! RecipeDetailsViewController
            dest.shouldFinish = false
            dest.recipe = (sender as! Recipe)
        }
    }
    
    func finish(){
        if !checkStep(){
            return
        }
        
        recipe!.userId = (UIApplication.shared.delegate as! AppDelegate).user?.id!
        
        RecipeService.getInstance().createRecipe(recipe: recipe!, recipeImage: recipeImage!, images: images!) { (isSuccess, recipeId)  in
            print(isSuccess)
            if !isSuccess{
                self.showAlert(title: "Error", message: "An error has occured on the server. We apologize.")
                return
            }
            RecipeService.getInstance().getRecipe(recipeId: recipeId, completionHandler: { (recipe) in
                self.performSegue(withIdentifier: "toRecipeDetails", sender: recipe)
            })
        }
    }
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        step?.description = textView.text
    }
}
