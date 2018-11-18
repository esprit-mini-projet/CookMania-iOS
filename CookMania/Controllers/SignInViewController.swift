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
import SwiftKeychainWrapper

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let CLIEND_ID = "323514335162-ut1n697tbepfjk414bsiju9g5fo567h4.apps.googleusercontent.com"
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    //Temp func call
    func logoutAll() {AccessToken.current = nil
        UserProfile.current = nil
        let loginManager = LoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance()?.signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "cookmania_user_id")
        KeychainWrapper.standard.removeObject(forKey: "cookmania_user_email")
        KeychainWrapper.standard.removeObject(forKey: "cookmania_user_password")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = CLIEND_ID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        initLoginButton()
        initFacebookButton()
        initGoogleButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Temp func call
        //logoutAll()
        
        //Facebook User is already connected
        if KeychainWrapper.standard.string(forKey: "cookmania_user_id") != nil{
            SignIn(email: KeychainWrapper.standard.string(forKey: "cookmania_user_email")!, password: KeychainWrapper.standard.string(forKey: "cookmania_user_password")!)
        }else if AccessToken.current != nil {
            continueToHome()
        }else{
            //Google User is aleady connected
            GIDSignIn.sharedInstance()?.signInSilently()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            self.appDelegate?.user = User(id: (self.appDelegate?.GOOGLE_UID_PREFIX)!+user.userID, email: user.profile.email, username: user.profile.name, imageUrl: (user.profile.imageURL(withDimension: 200)?.absoluteString)!)
            checkSocialUserExistance()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // change 2 to desired number of seconds
                self.continueToHome()
            }
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
    
    func continueToHome() {
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    func fetchProfileFB() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, picture.type(large)"])
        request.start { respons, result in
            switch result {
            case .failed(_):
                self.showErrorAlert(title: "Error", message: "Something went wrong, please try again.")
                break;
            case .success(let response):
                let dictionary = response.dictionaryValue
                var imageUrl: String = ""
                if let picture = dictionary?["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                    imageUrl = url
                }
                if let email = dictionary?["email"] as? String, let firstName = dictionary?["first_name"] as? String, let lastName = dictionary?["last_name"] as? String, let id = dictionary?["id"] as? String {
                    self.appDelegate!.user = User(id: (self.appDelegate?.FACEBOOK_UID_PREFIX)!+id, email: email, username: firstName+" "+lastName, imageUrl: imageUrl)
                    self.checkSocialUserExistance()
                    self.continueToHome()
                }
                break;
            }
        }
    }
    
    func checkSocialUserExistance() {
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.showErrorAlert(title: "Sorry", message: "En error hase occured while trying to log you in, please try again.")
                break
            case .cancelled:
                break
            case .success( _, _, _):
                self.fetchProfileFB()
                break
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) -> UIImage{
        var image: UIImage? = nil
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                image = UIImage(data: data)!
            }
        }
        return image!
    }
    
    func showErrorAlert(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            SignIn(email: email, password: password)
        }
    }
    
    func SignIn(email: String, password: String) {
        UserService.getInstance().logUserIn(email: email, password: password, completionHandler: { user in
            self.appDelegate?.user = user
            if KeychainWrapper.standard.integer(forKey: "cookmania_user_id") != nil{
                KeychainWrapper.standard.removeObject(forKey: "cookmania_user_id")
                KeychainWrapper.standard.removeObject(forKey: "cookmania_user_email")
                KeychainWrapper.standard.removeObject(forKey: "cookmania_user_password")
            }
            if KeychainWrapper.standard.set(user.id!, forKey: "cookmania_user_id") && KeychainWrapper.standard.set(user.email!, forKey: "cookmania_user_email") && KeychainWrapper.standard.set(user.password!, forKey: "cookmania_user_password"){
                self.continueToHome()
            }
        })
    }
}

