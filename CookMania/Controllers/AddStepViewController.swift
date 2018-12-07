//
//  AddStepViewController.swift
//  CookMania
//
//  Created by Elyes on 12/7/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class AddStepViewController: UIViewController {

    var recipe: Recipe?
    var recipeImage: UIImage?
    var images: [UIImage?]?
    
    var containerController: AddStepContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddStepContainer"{
            let dest = segue.destination as! AddStepContainerViewController
            containerController = dest
            dest.recipe = recipe
            dest.recipeImage = recipeImage
            dest.images = images
        }
    }
    
    
    @IBAction func finish(_ sender: Any) {
        containerController!.finish()
    }
    
    //TODO: Handle removing last step and image on going back
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            // Your code...
        }
    }
    
}
