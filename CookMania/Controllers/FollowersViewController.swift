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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        UserService.getInstance().getUserFollowers(usre: appDelegate.user!, completionHandler: { followers in
            self.followers = followers
            self.followersTableView.reloadData()
        })
        // Do any additional setup after loading the view.
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
        return UISwipeActionsConfiguration(actions: [removeFollowerAction, followBackAction])
    }
    
    func removeFollower(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Remove follower") { (action, view, completion) in
            print("Remove follower")
            completion(true)
        }
        action.image = UIImage(named: "unfollow")
        action.backgroundColor = UIColor.red
        return action
    }
    
    func followBack(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Follow back") { (action, view, completion) in
            print("Follow Back")
            completion(true)
        }
        action.image = UIImage(named: "follow")
        action.backgroundColor = UIColor.blue
        return action
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
