//
//  ViewController.swift
//  CookMania
//
//  Created by Elyes on 11/2/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var loginButton: UIButton!
    let CLIEND_ID = "323514335162-ut1n697tbepfjk414bsiju9g5fo567h4.apps.googleusercontent.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = CLIEND_ID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        initLoginButton()
        initFacebookButton()
        initGoogleButton()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func initLoginButton() {
        loginButton.backgroundColor = UIColor(displayP3Red: 71/255, green: 121/255, blue: 152/255, alpha: 1)
        loginButton.tintColor = UIColor.white
        loginButton.layer.cornerRadius = 13.0
    }
    
    func initGoogleButton() {
        googleLoginButton.backgroundColor = UIColor(displayP3Red: 221/255, green: 81/255, blue: 68/255, alpha: 1)
        googleLoginButton.tintColor = UIColor.white
        googleLoginButton.layer.cornerRadius = 13.0
    }
    
    func initFacebookButton() {
        facebookLoginButton.backgroundColor = UIColor(displayP3Red: 59/255, green: 89/255, blue: 153/255, alpha: 1)
        facebookLoginButton.tintColor = UIColor.white
        facebookLoginButton.layer.cornerRadius = 13.0
    }

    @IBAction func login(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                print("Logged in!")
            }
        }
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

