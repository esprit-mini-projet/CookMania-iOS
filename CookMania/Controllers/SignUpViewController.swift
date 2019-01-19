//
//  SignUpViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    var formTableViewController: FormTableViewController?
    var signinViewController: SignInViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        formTableViewController!.doneClicked(sender)
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserForm" {
            formTableViewController = segue.destination as? FormTableViewController
            formTableViewController?.doneButton = doneBarButtonItem
            formTableViewController?.signinViewController = signinViewController
            formTableViewController?.signupViewControoler = self
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
