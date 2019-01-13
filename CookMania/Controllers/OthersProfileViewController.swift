//
//  OthersProfileViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 1/12/19.
//  Copyright © 2019 MiniProjet. All rights reserved.
//

import UIKit

class OthersProfileViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user: User?
    var unfollowButton: UIBarButtonItem?
    var followButton: UIBarButtonItem?
    @IBOutlet weak var barButtonNavigation: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unfollowButton = UIBarButtonItem(title: "Unfollow", style: UIBarButtonItem.Style.plain, target: self, action: #selector(unfollow))
        followButton = UIBarButtonItem(title: "Follow", style: UIBarButtonItem.Style.plain, target: self, action: #selector(follow))
    }
    
    @objc func follow(){
        UserService.getInstance().follow(follower: self.appDelegate.user!, followed: self.user!, completionHandler: {
            self.updateBarButtonMenu()
        })
    }
    
    @objc func unfollow(){
        UserService.getInstance().unfollow(follower: self.appDelegate.user!, followed: self.user!, completionHandler: {
            self.updateBarButtonMenu()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateBarButtonMenu()
    }
    
    func updateBarButtonMenu() {
        UserService.getInstance().getUserFollowing(user: (self.appDelegate.user)!, completionHandler: { followings in
            let following = followings.first(where: { $0.following?.id == self.user?.id})
            if following == nil {
                self.barButtonNavigation.rightBarButtonItems = [self.followButton] as? [UIBarButtonItem]
            }else{
                self.barButtonNavigation.rightBarButtonItems = [self.unfollowButton] as? [UIBarButtonItem]
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            (segue.destination as! ProfileViewController).user = user
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
