//
//  AddRecipeViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var servingsText: UITextField!
    @IBOutlet weak var caloriesText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    
    var recipe: Recipe?
    var imageChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipe = Recipe()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(AddRecipeViewController.importImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
    }
    
    @objc func importImage(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        imageView.image = image
        imageChanged = true
    }
    
    @IBAction func addSteps(_ sender: Any){
        /*guard imageChanged else{
            showAlert()
            return
        }
        guard let title = titleText.text, !title.isEmpty else{
            showAlert()
            return
        }
        guard let servings = servingsText.text, !servings.isEmpty else{
            showAlert()
            return
        }
        guard let calories = caloriesText.text, !calories.isEmpty else{
            showAlert()
            return
        }
        guard let time = timeText.text, !time.isEmpty else{
            showAlert()
            return
        }
        recipe?.name = title
        recipe?.servings = Int(servings)
        recipe?.calories = Int(calories)
        recipe?.time = Int(time)*/
        recipe!.steps = [Step]()
        performSegue(withIdentifier: "toAddStep", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddStep"{
            let dest = segue.destination as! AddStepViewController
            dest.recipe = recipe
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Information Missing", message: "Make sure to add all necessary information.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ok", style: .cancel, handler: nil)
        alert.addAction(action)
        
        self.present(alert,animated: true,completion: nil)
    }
}
