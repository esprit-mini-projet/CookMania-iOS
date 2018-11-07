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

class ViewController: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userProfilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fbBtn = LoginButton(readPermissions: [.publicProfile, .email])
        fbBtn.center = view.center
        fbBtn.delegate = self
        view.addSubview(fbBtn)
    }

    @IBAction func login(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .cancelled:
            statusLabel.text = "User canceled login"
            break
        case .failed(_):
            statusLabel.text = "Error logging in"
            break
        case .success(_,_,_):
            statusLabel.text = "User LoggedIn"
            fetchProfileFB()
            break
        }
    }
    
    func fetchProfileFB() {
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, picture.type(large)"])
        request.start { respons, result in
            switch result {
            case .failed(_):
                self.showAlertError(title: "Error", message: "Something went wrong, please try again.")
                break;
            case .success(let response):
                let dictionary = response.dictionaryValue
                var imageUrl: String = ""
                if let picture = dictionary?["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                    imageUrl = url
                }
                if let email = dictionary?["email"] as? String, let firstName = dictionary?["first_name"] as? String, let lastName = dictionary?["last_name"] as? String, let id = dictionary?["id"] as? String {
                    let user = User(id: id, email: email, firstName: firstName, lastName: lastName, imageUrl: imageUrl)
                    print(user)
                }
                break;
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) -> UIImage{
        print("Download Started")
        var image: UIImage? = nil
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                image = UIImage(data: data)!
            }
        }
        return image!
    }
    
    func showAlertError(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        statusLabel.text = "User LoggedOut"
    }
}

