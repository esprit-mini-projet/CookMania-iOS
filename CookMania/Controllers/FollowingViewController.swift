//
//  FollowingViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/27/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

class FollowingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var followingTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dateFormatter = DateFormatter()
    var following: [Following] = []
    var followingLabel: UILabel?
    var profileViewController: ProfileViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        updateTableView()
        // Do any additional setup after loading the view.
    }
    
    func updateTableView() {
        UserService.getInstance().getUserFollowing(user: appDelegate.user!, completionHandler: { following in
            self.following = following
            self.profileViewController?.followingCountLabel.text = String(following.count)
            self.followingTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return following.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingCell")
        let contentView = cell?.viewWithTag(0)
        let shadowView = contentView?.viewWithTag(1) as! UIView
        let cardView = contentView?.viewWithTag(2) as! UIView
        let imageShadowView = cardView.viewWithTag(3) as! UIView
        let imageView = cardView.viewWithTag(4) as! UIImageView
        let nameLabel = cardView.viewWithTag(5) as! UILabel
        let dateLabel = cardView.viewWithTag(6) as! UILabel
        
        let following = self.following[indexPath.item]
        
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
        imageView.af_setImage(withURL: URL(string: (following.following?.imageUrl)!)!)
        nameLabel.text = following.following?.username
        dateLabel.text = dateFormatter.string(from: following.date!)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unfollowAction = unfollow(at: indexPath)
        return UISwipeActionsConfiguration(actions: [unfollowAction])
    }
    
    func unfollow(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Unfollow") { (action, view, completion) in
            let following = self.following[indexPath.item].following!
            let alert = UIAlertController(title: "Confirmation", message: "Do you really want to unfollow "+following.username!+"?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                UserService.getInstance().unfollow(follower: self.appDelegate.user!, followed: following, completionHandler: {
                    self.updateTableView()
                    let alertDisapperTimeInSeconds = 2.0
                    let alert = UIAlertController(title: nil, message: "You have unfollowed "+following.username!, preferredStyle: .actionSheet)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
