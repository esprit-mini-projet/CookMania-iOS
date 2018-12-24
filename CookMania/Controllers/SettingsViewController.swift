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

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTableView: UITableView!
    
    var menu: [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if appDelegate.user?.id?.prefix(1) == "f" {
                menu.append(MenuItem(name: "Linked to facebook account", icon: UIImage(named: "facebook")!, iconTintColor: UIColor(red: 71, green: 121, blue: 152), clickHandler: {
                    self.performSegue(withIdentifier: "toUserForm", sender: nil)
                }))
            }else if appDelegate.user?.id?.prefix(1) == "g" {
                menu.append(MenuItem(name: "Linked to google account", icon: UIImage(named: "google")!, iconTintColor: UIColor(red: 71, green: 121, blue: 152), clickHandler: {
                }))
            }else{
                menu.append(MenuItem(name: "Edit Account", icon: UIImage(named: "edit")!, iconTintColor: UIColor(red: 71, green: 121, blue: 152), clickHandler: {
                    print("Edit clicked")
                }))
            }
        }
        menu.append(MenuItem(name: "Lougout", icon: UIImage(named: "logout")!, iconTintColor: UIColor(red: 71, green: 121, blue: 152), clickHandler: {
            UserService.getInstance().logout(completionHandler: {
                UserProfile.current = nil
                let loginManager = LoginManager()
                loginManager.logOut()
                GIDSignIn.sharedInstance()?.signOut()
                
                KeychainWrapper.standard.removeObject(forKey: "cookmania_user_id")
                KeychainWrapper.standard.removeObject(forKey: "cookmania_user_email")
                KeychainWrapper.standard.removeObject(forKey: "cookmania_user_password")
                self.dismiss(animated: true, completion: nil)
            })
        }))
        menu.append(MenuItem(name: "Remove Account", icon: UIImage(named: "remove")!, iconTintColor: UIColor(red: 221, green: 81, blue: 68), clickHandler: {
            print("Remove clicked")
        }))
        menuTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell")
        let menuItem = menu[indexPath.item]
        
        let contentView = cell?.viewWithTag(0)
        let iconView = contentView?.viewWithTag(1) as! UIImageView
        let label = contentView?.viewWithTag(2) as! UILabel
        
        iconView.image = menuItem.icon
        iconView.tintColor = menuItem.iconTintColor
        label.text = menuItem.name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menu[indexPath.item]
        menuItem.clickHandler()
        tableView.deselectRow(at: indexPath, animated: true)
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
