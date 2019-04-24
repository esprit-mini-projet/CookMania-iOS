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
    var notification: NotificationWrapper?
    
    func logout(){
        let loginManager = LoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance()?.signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "cookmania_user_id")
        KeychainWrapper.standard.removeObject(forKey: "cookmania_user_email")
        KeychainWrapper.standard.removeObject(forKey: "cookmania_user_password")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //logout()
        UIApplication.shared.statusBarStyle = .lightContent
        GIDSignIn.sharedInstance().clientID = CLIEND_ID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        initLoginButton()
        initFacebookButton()
        initGoogleButton()
        
        checkForLogin()
    }
    
    func checkForLogin() {
        if (UIApplication.shared.delegate as! AppDelegate).reachability.connection != .none {
            print("Inside login")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //Temp func call
                //self.logoutAll()
                //Facebook User is already connected
                if KeychainWrapper.standard.string(forKey: "cookmania_user_email") != nil{
                    self.SignIn(email: KeychainWrapper.standard.string(forKey: "cookmania_user_email")!, password: KeychainWrapper.standard.string(forKey: "cookmania_user_password")!)
                }else if AccessToken.current != nil {
                    self.fetchProfileFB(withAccessToken: AccessToken.current!)
                }else if((GIDSignIn.sharedInstance()?.hasAuthInKeychain())!){
                    //Google User is aleady connected
                    GIDSignIn.sharedInstance()?.signInSilently()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        (UIApplication.shared.value(forKey: "statusBar") as! UIView).backgroundColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        (UIApplication.shared.value(forKey: "statusBar") as! UIView).backgroundColor = UIColor(rgb: 0x2E5065)
    }
    
    //Google signin
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let user = User(id: (self.appDelegate?.GOOGLE_UID_PREFIX)!+user.userID, email: user.profile.email, username: user.profile.name, imageUrl: (user.profile.imageURL(withDimension: 200)?.absoluteString)!)
            checkSocialUserExistance(user: user)
        } else {
            UIUtils.showErrorAlert(viewController: self)
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
        performSegue(withIdentifier: "toHome", sender: self)
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome"{
            let destination = segue.destination as? MainTabLayoutViewController
            destination?.notification = notification
            notification = nil
        }else if segue.identifier == "toSignUp"{
            let destination = segue.destination as? SignUpViewController
            destination?.signinViewController = self
        }
    }
    
    func fetchProfileFB(withAccessToken accessToken: AccessToken) {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, picture.type(large)"], accessToken: accessToken)
        request.start { respons, result in
            switch result {
            case .failed(_):
                UIUtils.showErrorAlert(viewController: self)
                break;
            case .success(let response):
                let dictionary = response.dictionaryValue
                var imageUrl: String = ""
                if let picture = dictionary?["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                    imageUrl = url
                }
                if let email = dictionary?["email"] as? String, let firstName = dictionary?["first_name"] as? String, let lastName = dictionary?["last_name"] as? String, let id = dictionary?["id"] as? String {
                    let user = User(id: (self.appDelegate?.FACEBOOK_UID_PREFIX)!+id, email: email, username: firstName+" "+lastName, imageUrl: imageUrl)
                    self.checkSocialUserExistance(user: user)
                }
                break;
            }
        }
    }
    
    func checkSocialUserExistance(user: User) {
        UserService.getInstance().checkUserSocial(user: user, completionHandler: { user in
            self.appDelegate?.user = user
            print("in check user existance")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // change 2 to desired number of seconds
                if KeychainWrapper.standard.set(user.id!, forKey: "cookmania_user_id") {
                    self.continueToHome()
                }
            }
        })
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { loginResult in
            switch loginResult {
            case .failed( _):
                UIUtils.showErrorAlert(title: "Sorry", message: "An error has occured while trying to log you in, please try again.", viewController: self)
                print("error here: ", loginResult)
                break
            case .cancelled:
                break
            case .success( _, _, _):
                self.fetchProfileFB(withAccessToken: AccessToken.current!)
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
    
    @IBAction func googleLogin(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            if !FormUtils.validateEmail(email: emailTextField.text!){
                let alert = UIAlertController(title: "Error", message: "This is not a valid email address!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
                return
            }
            SignIn(email: email, password: password)
        }
    }
    
    func SignIn(email: String, password: String) {
        UserService.getInstance().logUserIn(email: email, password: password, completionHandler: { user in
            if user != nil && (self.appDelegate?.setUser(user: user!))!{
                self.continueToHome()
            }else{
                let alert = UIAlertController(title: "Error", message: "Please verify your credentials.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}

