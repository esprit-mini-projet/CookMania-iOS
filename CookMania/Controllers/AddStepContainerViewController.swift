//
//  AddStepViewController.swift
//  CookMania
//
//  Created by Elyes on 11/28/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Gallery

class AddStepContainerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, GalleryControllerDelegate {
    
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
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descText.layer.borderColor = UIColor.lightGray.cgColor
        
        step = Step()
        step?.ingredients = [Ingredient(), Ingredient(), Ingredient()]
        
        descText.text = descriptionPlaceHolder
        descText.textColor = UIColor.lightGray
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
    
    func checkStep(){
        guard let desc = descText.text, !desc.isEmpty else{
            showAlert()
            return
        }
        for ingredient in step!.ingredients!{
            guard let name = ingredient.name, !name.isEmpty else{
                showAlert()
                return
            }
            guard let quantity = ingredient.quantity, quantity > 0 else{
                showAlert()
                return
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
    }
    
    @IBAction func addStep(_ sender: Any){
        checkStep()
        performSegue(withIdentifier: "toAddStep", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddStep"{
            let dest = segue.destination as! AddStepViewController
            dest.recipe = recipe
            dest.recipeImage = recipeImage
            dest.images = images
        }
    }
    
    func finish(){
        checkStep()
        
        recipe!.userId = (UIApplication.shared.delegate as! AppDelegate).user?.id!
        
        RecipeService.getInstance().createRecipe(recipe: recipe!, recipeImage: recipeImage!, images: images!) { (isSuccess)  in
            print(isSuccess)
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Information Missing", message: "Make sure to add all necessary information.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert,animated: true,completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = descriptionPlaceHolder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        step?.description = textView.text
    }
}
