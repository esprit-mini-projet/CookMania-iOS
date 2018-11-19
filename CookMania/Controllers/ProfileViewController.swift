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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dateFormatter = DateFormatter()
    var firstSemgmentIsVisible = true
    
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
        firstSemgmentIsVisible = !firstSemgmentIsVisible
        myRecipeViewContainer.alpha = firstSemgmentIsVisible ? 1 : 0
        favoriteViewContainer.alpha = !firstSemgmentIsVisible ? 1 : 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myRecipesContainerSegue" {
            (segue.destination as! MyRecipesViewController).myRecipeViewContainer = self.myRecipeViewContainer
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
