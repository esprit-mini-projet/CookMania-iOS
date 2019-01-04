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
    
    var doneButton: UIBarButtonItem?
    var signinViewController: SignInViewController?
    var signupViewControoler: SignUpViewController?
    
    var usernameIsValide: Bool = false
    var emailIsValide: Bool = false
    var passwordIsValide: Bool = false
    var confirmationIsValide: Bool = false
    var imageDidChange: Bool = false
    var usernameDidChange: Bool = false
    var emailDidChange: Bool = false
    var passwordDidChange: Bool = false
    
    var image: UIImage?
    var email: String = ""
    var password: String = ""
    var username: String = ""
    
    let user = (UIApplication.shared.delegate as! AppDelegate).user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if doneButton == nil {
            doneButton = doneButtonBarItem
        }
        doneButton!.isEnabled = false
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImageBlurContainer.layer.cornerRadius = profileImageBlurContainer.bounds.width / 2
        if user != nil {
            profileImage.af_setImage(withURL: URL(string: (user!.imageUrl)!)!)
            usernameIsValide = true
            emailIsValide = true
            passwordIsValide = true
            confirmationIsValide = true
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
            self.imageDidChange = true
            self.validateForm()
        })
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
    }
    
    func validateForm() {
        if user != nil {
            if usernameIsValide && emailIsValide && passwordIsValide && confirmationIsValide && (usernameDidChange || emailDidChange || imageDidChange || passwordDidChange) {
                doneButton!.isEnabled = true
                return
            }
        }else{
            if usernameIsValide && emailIsValide && passwordIsValide && confirmationIsValide {
                doneButton!.isEnabled = true
                return
            }
        }
        doneButton!.isEnabled = false
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        if user != nil {
            let newUser = User(id: (user?.id)!, email: email, username: username, password: password)
            UserService.getInstance().updateUser(user: newUser, image: image, completionHandler: {
                UserService.getInstance().getUser(id: (self.user?.id)!, completionHandler: { us in
                    if((UIApplication.shared.delegate as! AppDelegate).setUser(user: us)){
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }else{
            let newUser = User(email: email, username: username, password: password)
            UserService.getInstance().addUser(user: newUser, image: image, completionHandler: {
                self.signupViewControoler?.dismiss(animated: true, completion: {
                    self.signinViewController?.SignIn(email: self.email, password: self.password)
                })
            })
        }
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
