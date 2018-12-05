//
//  AddStepViewController.swift
//  CookMania
//
//  Created by Elyes on 11/28/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class AddStepViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let descriptionPlaceHolder = "Description..."
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var timeText: UITextField!

    var recipe: Recipe?
    var step: Step?
    var images: [UIImage]?
    var currentImage: UIImage?
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
            print(n)
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
        print(sender.titleForSegment(at: sender.selectedSegmentIndex))
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
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(AddRecipeViewController.importImage))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(singleTap)
        
        if let _ = step{
            loadFromStep()
            return
        }
        step = Step()
        step?.ingredients = [Ingredient(), Ingredient(), Ingredient()]
        tableView.reloadData()
        descText.text = descriptionPlaceHolder
        descText.textColor = UIColor.lightGray
    }
    
    func loadFromStep(){
        tableView.reloadData()
        
        if let desc = step?.description{
            descText.text = desc
        }
        
        guard let cgImage = currentImage?.cgImage?.copy() else {
            return
        }
        imageView.image = UIImage(cgImage: cgImage,
                               scale: imageView.image!.scale,
                               orientation: imageView.image!.imageOrientation)
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
    
    @IBAction func addIngredient(_ sender: Any){
        
    }
    
    @IBAction func addStep(_ sender: Any){
        
        recipe!.steps!.append(step!)
        step = nil
        self.viewDidLoad()
    }
    
    @IBAction func back(_ sender: Any){
        if recipe!.steps!.count == 0{
            navigationController?.popViewController(animated: true)
        }else{
            step = recipe!.steps!.popLast()
            self.viewDidLoad()
        }
    }
    
    @IBAction func finish(_ sender: Any){
        print("yo")
    }
    
    @IBAction func timeChanged(_ sender: Any){
        if let text = timeText.text{
            step?.time = Int(text)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
