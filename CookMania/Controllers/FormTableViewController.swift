//
//  FormTableViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 12/24/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class FormTableViewController: UITableViewController{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmationErrorLabel: UILabel!
    
    var userFormViewController: UserFormViewController?
    var usernameIsValide: Bool = false
    var emailIsValide: Bool = false
    var passwordIsValide: Bool = false
    var confirmationIsValide: Bool = false
    
    let user = (UIApplication.shared.delegate as! AppDelegate).user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            usernameTextField.text = user?.username
            emailTextField.text = user?.email
            usernameIsValide = true
            emailIsValide = true
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
        return 4
    }
    
    @IBAction func usernameDidChange(_ sender: Any) {
        if usernameTextField.text == "" {
            usernameIsValide = false
            usernameErrorLabel.text = "Username can't be empty"
            usernameErrorLabel.alpha = 1
        }else{
            usernameIsValide = true
            usernameErrorLabel.alpha = 0
        }
        validateForm()
    }
    
    @IBAction func emailDidChange(_ sender: Any) {
        if emailTextField.text == "" {
            emailIsValide = false
            emailErrorLabel.text = "Email can't be empty"
            emailErrorLabel.alpha = 1
        }else{
            emailIsValide = true
            emailErrorLabel.alpha = 0
        }
        validateForm()
    }
    
    @IBAction func passwordDidChange(_ sender: Any) {
        if user == nil && passwordTextField.text == "" {
            passwordIsValide = false
            passwordErrorLabel.text = "Password can't be empty"
            passwordErrorLabel.alpha = 1
        }else{
            confirmationIsValide = validateConfirmation()
            passwordIsValide = true
            passwordErrorLabel.alpha = 0
        }
        validateForm()
    }
    
    @IBAction func confirmationDidChange(_ sender: Any) {
        confirmationIsValide = validateConfirmation()
        validateForm()
    }
    
    func validateConfirmation() -> Bool {
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
    
    func validateForm() {
        if user != nil {
            if usernameIsValide && emailIsValide && ((passwordIsValide && confirmationIsValide) || (usernameTextField.text != user?.username || emailTextField.text != user?.email)) {
                userFormViewController?.doneButtonBarItem.isEnabled = true
                return
            }
        }else{
            if usernameIsValide && emailIsValide && passwordIsValide && confirmationIsValide {
                userFormViewController?.doneButtonBarItem.isEnabled = true
                return
            }
        }
        userFormViewController?.doneButtonBarItem.isEnabled = false
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
