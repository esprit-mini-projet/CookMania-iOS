//
//  AddExperienceViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/29/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Cosmos

class AddExperienceViewController: UIViewController {
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var rating: Double?
    var recipe: Recipe?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingView.rating = rating!
        ratingView.settings.fillMode = .precise
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.masksToBounds = true
        commentTextView.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let experience = Experience(user: appDelegate.user!, rating: Float(ratingView.rating), comment: commentTextView.text!, imageUrl: "")
        ExperienceService.getInstance().addRecipeExperience(experience: experience, recipeId: (recipe?.id)!, completionHandler: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
