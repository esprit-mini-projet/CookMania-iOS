//
//  ProfileViewController.swift
//  CookMania
//
//  Created by Elyes on 11/7/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileCoverImageView: UIImageView!
    @IBOutlet weak var profilePhotoShadowView: UIView!
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myRecipeViewContainer: UIView!
    @IBOutlet weak var favoriteViewContainer: UIView!
    @IBOutlet weak var profileSegmentedController: UISegmentedControl!
    @IBOutlet weak var followerViewContainer: UIView!
    @IBOutlet weak var followingViewContainer: UIView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dateFormatter = DateFormatter()
    
    var followersViewController: FollowersViewController?
    var followingViewController: FollowingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.width / 2
        profilePhotoImageView.layer.borderWidth = 5
        profilePhotoImageView.layer.borderColor = UIColor.white.cgColor
        
        profilePhotoShadowView.layer.cornerRadius = profilePhotoImageView.frame.height / 2
        profilePhotoShadowView.layer.shadowColor = UIColor.black.cgColor
        profilePhotoShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        profilePhotoShadowView.layer.shadowOpacity = 0.8
        
        dateFormatter.dateFormat = "dd MMM, yyyy"
        
        //segmentedController.removeSegment(at: 1, animated: false)
        
        populateFields()
    }
    
    func populateFields() {
        let user = appDelegate.user!
        print(user.imageUrl!)
        profilePhotoImageView.af_setImage(withURL: URL(string: (user.imageUrl)!)!)
        followingCountLabel.text = String(user.following)
        followersCountLabel.text = String(user.followers)
        nameLabel.text = user.username!
        dateLabel.text = dateFormatter.string(from: user.date!)
    }
    
    @IBAction func segmentDidChange(_ sender: Any) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            myRecipeViewContainer.alpha = 1
            favoriteViewContainer.alpha = 0
            followerViewContainer.alpha = 0
            followingViewContainer.alpha = 0
            break
        case 1:
            myRecipeViewContainer.alpha = 0
            favoriteViewContainer.alpha = 1
            followerViewContainer.alpha = 0
            followingViewContainer.alpha = 0
            break
        case 2:
            myRecipeViewContainer.alpha = 0
            favoriteViewContainer.alpha = 0
            followerViewContainer.alpha = 1
            followingViewContainer.alpha = 0
            break
        case 3:
            myRecipeViewContainer.alpha = 0
            favoriteViewContainer.alpha = 0
            followerViewContainer.alpha = 0
            followingViewContainer.alpha = 1
            break
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myRecipesContainerSegue" {
            (segue.destination as! MyRecipesViewController).myRecipeViewContainer = self.myRecipeViewContainer
        }else if segue.identifier == "followingContainerSegue" {
            followingViewController = (segue.destination as! FollowingViewController)
            followingViewController!.profileViewController = self
        }else if segue.identifier == "followersContainerSegue" {
            followersViewController = (segue.destination as! FollowersViewController)
            followersViewController!.profileViewController = self
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
