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
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    //Temp func call
    func logoutSocial() {AccessToken.current = nil
        UserProfile.current = nil
        let loginManager = LoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance()?.signOut()
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
        //logoutSocial()
        
        //Facebook User is already connected
        if AccessToken.current != nil {
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
                print("####################### ERROR #######################")
                print(error)
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
}

