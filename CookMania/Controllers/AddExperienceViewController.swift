//
//  AddExperienceViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/29/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Cosmos
import Gallery

class AddExperienceViewController: UIViewController, GalleryControllerDelegate {
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var coverImagePreview: UIImageView!
    
    var rating: Double?
    var recipe: Recipe?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var experienceImage: UIImage?
    
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
        ExperienceService.getInstance().addRecipeExperience(experience: experience, image: experienceImage!, recipeId: (recipe?.id)!, completionHandler: {
            self.navigationController?.popViewController(animated: true)
        })
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
            self.coverImagePreview.image = image!
            self.experienceImage = image!
        })
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
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
