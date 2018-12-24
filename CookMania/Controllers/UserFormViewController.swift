//
//  UserFormViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 12/23/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Gallery

class UserFormViewController: UIViewController, GalleryControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageBlurContainer: UIView!
    @IBOutlet weak var doneButtonBarItem: UIBarButtonItem!
    
    var image: UIImage?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButtonBarItem.isEnabled = false
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImageBlurContainer.layer.cornerRadius = profileImageBlurContainer.bounds.width / 2
        if appDelegate.user != nil {
            profileImage.af_setImage(withURL: URL(string: (appDelegate.user?.imageUrl)!)!)
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFormTable" {
            let destination = segue.destination as! FormTableViewController
            destination.userFormViewController = self
        }
    }
    
    @IBAction func addImageClicked(_ sender: Any) {
        Config.tabsToShow = [.cameraTab, .imageTab]
        Config.Camera.imageLimit = 1
        
        let gallery = GalleryController()
        gallery.delegate = self
        present(gallery, animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
        images[0].resolve(completion: { image in
            self.image = image!
            self.profileImage.image = image!
        })
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
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
