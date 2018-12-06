//
//  AddRecipeViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UITextViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    let blue = UIColor(red: 71/255, green: 121/255, blue: 152/255, alpha: 1.0)
    let white = UIColor.white
    var labelColor: CGColor?
    let descriptionPlaceHolder = "Description..."
    let labels = ["Cheap", "Easy", "Kids Friendly", "Expensive", "Healthy", "Date Night",
                  	"Fast", "Take Time", "Beginner Friendly", "Breakfast", "Dinner"]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var servingsText: UITextField!
    @IBOutlet weak var caloriesText: UITextField!
    @IBOutlet weak var timeText: UITextField!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var labelsCV: UICollectionView!
    
    var recipe: Recipe?
    var imageChanged = false
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let label = labels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Label", for: indexPath)
        let button = cell.viewWithTag(1) as! UIButton
        button.setTitle(label, for: .normal)
        button.addTarget(self, action: #selector(AddRecipeViewController.highlight), for: UIControl.Event.touchUpInside)
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
            return
        }
        sender.backgroundColor = white
        sender.setTitleColor(UIColor(cgColor: labelColor!), for: .normal)
        sender.layer.borderWidth = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipe = Recipe()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(AddRecipeViewController.importImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        
        descText.text = descriptionPlaceHolder
        descText.textColor = UIColor.lightGray
        descText.layer.borderColor = UIColor.lightGray.cgColor
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
        guard imageChanged else{
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
        recipe?.time = Int(time)
        recipe!.steps = [Step]()
        performSegue(withIdentifier: "toAddStep", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddStep"{
            let dest = segue.destination as! AddStepViewController
            dest.recipe = recipe
            dest.recipeImage = imageView.image
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
}
