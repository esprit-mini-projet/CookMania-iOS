//
//  FollowersViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/19/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import AlamofireImage

class FollowersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var followersTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dateFormatter = DateFormatter()
    var followers: [Following] = []
    var connectedUserFollowing: [Following] = []
    var followersLabel: UILabel?
    var profileViewController: ProfileViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        //updateTableView()
        // Do any additional setup after loading the view.
    }
    
    func updateTableView() {
        UserService.getInstance().getUserFollowers(user: (profileViewController?.user)!, completionHandler: { followers in
            self.followers = followers
            self.profileViewController?.followersCountLabel.text = String(followers.count)
            UserService.getInstance().getUserFollowing(user: (self.appDelegate.user)!, completionHandler: { following in
                self.connectedUserFollowing = following
                self.followersTableView.reloadData()
            })
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell")
        let contentView = cell?.viewWithTag(0)
        let shadowView = contentView?.viewWithTag(1) as! UIView
        let cardView = contentView?.viewWithTag(2) as! UIView
        let imageShadowView = cardView.viewWithTag(3) as! UIView
        let imageView = cardView.viewWithTag(4) as! UIImageView
        let nameLabel = cardView.viewWithTag(5) as! UILabel
        let dateLabel = cardView.viewWithTag(6) as! UILabel
        
        let follower = self.followers[indexPath.item]
        
        //prepare the view
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.height / 2
        
        imageShadowView.layer.cornerRadius = imageView.frame.height / 2
        imageShadowView.layer.shadowColor = UIColor.black.cgColor
        imageShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageShadowView.layer.shadowOpacity = 0.8
        
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        shadowView.layer.shadowOpacity = 0.7
        
        //populateData
        imageView.af_setImage(withURL: URL(string: (follower.follower?.imageUrl)!)!)
        nameLabel.text = follower.follower?.username
        dateLabel.text = dateFormatter.string(from: follower.date!)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeFollowerAction = removeFollower(at: indexPath)
        let followBackAction = followBack(at: indexPath)
        let follower = followers[indexPath.item]
        
        var actions: [UIContextualAction] = []
        
        if (!(self.connectedUserFollowing.contains(where: { $0.following?.id == follower.follower?.id})) && follower.follower?.id != appDelegate.user?.id ){
            actions.append(followBackAction)
        }
        if (profileViewController?.user?.id == appDelegate.user?.id) {
            actions.append(removeFollowerAction)
        }
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    func removeFollower(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            let follower = self.followers[indexPath.item].follower!
            let alert = UIAlertController(title: "Confirmation", message: "Do you really want to remove "+follower.username!+"'s follow?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                UserService.getInstance().unfollow(follower: follower, followed: self.appDelegate.user!, completionHandler: {
                    self.updateTableView()
                    let alertDisapperTimeInSeconds = 2.0
                    let alert = UIAlertController(title: nil, message: "You have removed "+follower.username!+"'s follow", preferredStyle: .actionSheet)
                    self.present(alert, animated: true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                        alert.dismiss(animated: true)
                    }
                })
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            completion(true)
        }
        action.image = UIImage(named: "unfollow")
        action.backgroundColor = UIColor.red
        return action
    }
    
    func followBack(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            let followed = self.followers[indexPath.item].follower!
            UserService.getInstance().follow(follower: self.appDelegate.user!, followed: followed, completionHandler: {
                self.profileViewController?.followingViewController?.updateTableView()
                let alertDisapperTimeInSeconds = 2.0
                let alert = UIAlertController(title: nil, message: "You are following "+followed.username!, preferredStyle: .actionSheet)
                self.present(alert, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + alertDisapperTimeInSeconds) {
                    alert.dismiss(animated: true)
                }
            })
            
            completion(true)
        }
        action.image = UIImage(named: "follow")
        action.backgroundColor = UIColor.blue
        return action
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toProfile", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            let destination = segue.destination as! ProfileViewController
            let user = followers[(sender as! IndexPath).item].follower!
            
            destination.user = user
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
