//
//  EditProfileViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn
import SwiftKeychainWrapper

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        UserProfile.current = nil
        let loginManager = LoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance()?.signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "cookmania_user_id")
        KeychainWrapper.standard.removeObject(forKey: "cookmania_user_email")
        KeychainWrapper.standard.removeObject(forKey: "cookmania_user_password")
        dismiss(animated: true, completion: nil)
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
