//
//  AddRecipeViewController.swift
//  CookMania
//
//  Created by Elyes on 12/7/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController {

    var containerController: AddRecipeContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addSteps(_ sender: Any) {
        if let recipe = containerController!.checkRecipe() {
            performSegue(withIdentifier: "toAddStep", sender: recipe)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddRecipeContainer"{
            containerController = segue.destination as? AddRecipeContainerViewController
        }else if segue.identifier == "toAddStep"{
            let dest = segue.destination as! AddStepViewController
            let recipe = sender as! Recipe
            dest.recipe = recipe
            dest.recipeImage = containerController!.imageView.image
            dest.images = [UIImage]()
        }
    }
    
}
