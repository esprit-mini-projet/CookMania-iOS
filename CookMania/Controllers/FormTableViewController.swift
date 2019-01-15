//
//  FormTableViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 12/24/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Gallery

class FormTableViewController: UITableViewController, GalleryControllerDelegate{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmationErrorLabel: UILabel!
    @IBOutlet var formTableView: UITableView!
    @IBOutlet weak var doneButtonBarItem: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileImageBlurContainer: UIView!
    
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
        if user != nil {
            usernameTextField.text = user?.username
            emailTextField.text = user?.email
        }
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    @IBAction func usernameDidChange(_ sender: Any) {
        self.username = usernameTextField.text!
        if usernameTextField.text == "" {
            self.usernameIsValide = false
            usernameErrorLabel.text = "Username can't be empty"
            usernameErrorLabel.alpha = 1
        }else{
            if usernameTextField.text != user?.username{
                self.usernameDidChange = true
            }else {
                self.usernameDidChange = false
            }
            self.usernameIsValide = true
            usernameErrorLabel.alpha = 0
        }
        self.validateForm()
    }
    
    @IBAction func emailDidChange(_ sender: Any) {
        self.email = emailTextField.text!
        if emailTextField.text == ""{
            self.emailIsValide = false
            emailErrorLabel.text = "Email can't be empty"
            emailErrorLabel.alpha = 1
        }else if !FormUtils.validateEmail(email: emailTextField.text!){
            self.emailIsValide = false
            emailErrorLabel.text = "Email is not valid"
            emailErrorLabel.alpha = 1
        }else{
            if user != nil && emailTextField.text != user?.email {
                self.emailDidChange = true
            }else{
                self.emailDidChange = false
            }
            self.emailIsValide = true
            emailErrorLabel.alpha = 0
        }
        self.validateForm()
    }
    
    @IBAction func passwordDidChange(_ sender: Any) {
        if user == nil && passwordTextField.text == "" {
            self.passwordIsValide = false
            self.passwordDidChange = false
            passwordErrorLabel.text = "Password can't be empty"
            passwordErrorLabel.alpha = 1
        }else{
            if passwordTextField.text == "" {
                self.passwordDidChange = false
            }else{
                self.passwordDidChange = true
            }
            self.confirmationIsValide = validateConfirmation()
            self.passwordIsValide = true
            passwordErrorLabel.alpha = 0
        }
        self.validateForm()
    }
    
    @IBAction func confirmationDidChange(_ sender: Any) {
        self.confirmationIsValide = validateConfirmation()
        self.validateForm()
    }
    
    func validateConfirmation() -> Bool {
        self.password = confirmationTextField.text!
        if user == nil && confirmationTextField.text == ""{
            confirmationErrorLabel.text = "Confirmation can't be empty"
            confirmationErrorLabel.alpha = 1
            return false
        }else if confirmationTextField.text != passwordTextField.text {
            confirmationErrorLabel.text = "Different than password"
            confirmationErrorLabel.alpha = 1
            return false
        }else{
            confirmationErrorLabel.alpha = 0
            return true
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
