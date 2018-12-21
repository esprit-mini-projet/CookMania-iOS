//
//  RecipeDetailsViewController.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/8/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import AlamofireImage
import CoreData
import ISPageControl

class RecipeDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    class LocalIngredient: NSObject {
        var id: Int
        var name: String
        var quantity: Float
        var unit: String
        
        init(id: Int, name: String, quantity: Float, unit: String) {
            self.id = id
            self.name = name
            self.quantity = quantity
            self.unit = unit
        }
    }
    
    class LocalStep: NSObject {
        var name: String
        var desc: String
        var time: Int
        var imageUrl: String
        var ingredients: [LocalIngredient]
        
        init(name: String, desc: String, time: Int,imageUrl: String, ingredients: [LocalIngredient]) {
            self.name = name
            self.desc = desc
            self.time = time
            self.imageUrl = imageUrl
            self.ingredients = ingredients
        }
    }
    
    class LocalRecipe: NSObject {
        var id: Int
        var name: String
        var rating: Float
        var imageUrl: String
        var time: Int
        var calories: Int
        var servings: Int
        var steps: [LocalStep]
        var ingredients: [LocalIngredient]
        var desc: String
        
        init(id: Int, name: String, desc: String, rating: Float, imageUrl: String, time: Int, calories: Int, servings: Int, steps: [LocalStep], ingredients: [LocalIngredient]){
            self.id = id
            self.name = name
            self.desc = desc
            self.rating = rating
            self.imageUrl = imageUrl
            self.time = time
            self.calories = calories
            self.servings = servings
            self.steps = steps
            self.ingredients = ingredients
        }
    }
    
    @IBOutlet weak var recipeCoverIV: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var ingredientsStack: UIStackView!
    @IBOutlet weak var servingsStack: UIStackView!
    @IBOutlet weak var ingredientsValueLabel: UILabel!
    @IBOutlet weak var caloriesValueLabel: UILabel!
    @IBOutlet weak var servingsValueLabel: UILabel!
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stepsTableView: UITableView!
    @IBOutlet weak var stepsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var ingredientsTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var similarRecipesCollectionView: UICollectionView!
    @IBOutlet weak var similarRecipiesLabel: UILabel!
    @IBOutlet weak var experiencesCollectionView: UICollectionView!
    @IBOutlet weak var recipeRatingInput: CosmosView!
    @IBOutlet weak var recipeDescriptionTextView: UITextView!
    
    @IBOutlet weak var recipeOwnerView: UIView!
    @IBOutlet weak var recipeOwnerProfileImageView: UIImageView!
    @IBOutlet weak var recipeOwnerProfileImageShadowView: UIView!
    @IBOutlet weak var recipeOwnerNameLabel: UILabel!
    @IBOutlet weak var recipeOwnerDateLabel: UILabel!
    @IBOutlet weak var recipeOwnerViewExpandedConstraint: NSLayoutConstraint!
    @IBOutlet weak var addToFavoriteBarButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var visitProfileButton: UIButton!
    @IBOutlet weak var experiencesPageController: ISPageControl!
    
    
    
    var experiences = [Experience]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favorite: NSManagedObject?
    var recipe: Recipe?
    var user: User?
    var ingredients: [Ingredient] = []
    
    var similarRecipes = [
        LocalRecipe(id: 3, name: "Melanzana", desc: "I have a View which has two labels and a Table View inside it. I want label 1 to always stay above my Table View and label 2, to be below the Table View. The problem is that the Table View needs to auto-size meaning either increase in height or decrease.Right now I have a constraint saying the Table View's height is always equal to 85 and a @IBOutlet to the height constraint where i'm able to change the constant.", rating: Float(3.0), imageUrl: "melanzana", time: 20, calories: 367, servings: 4, steps: [
            LocalStep(name: "Prepare tatatata", desc: "", time: 0, imageUrl: "", ingredients: [LocalIngredient]()),
            LocalStep(name: "Cook the sauce", desc: "Let it simmer for 3 mintues", time: 4, imageUrl: "melanzana", ingredients: [
                LocalIngredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                LocalIngredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                LocalIngredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
                ]),
            LocalStep(name: "Let rest for 4 minutes", desc: "", time: 4, imageUrl: "melanzana", ingredients: [])
            ], ingredients: [
                LocalIngredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                LocalIngredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                LocalIngredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
            ]
        ),
        LocalRecipe(id: 3, name: "Melanzana", desc: "I have a View which has two labels and a Table View inside it. I want label 1 to always stay above my Table View and label 2, to be below the Table View. The problem is that the Table View needs to auto-size meaning either increase in height or decrease.Right now I have a constraint saying the Table View's height is always equal to 85 and a @IBOutlet to the height constraint where i'm able to change the constant.", rating: 3.0, imageUrl: "melanzana", time: 20, calories: 367, servings: 4, steps: [
            LocalStep(name: "Prepare tatatata", desc: "", time: 0, imageUrl: "melanzana", ingredients: []),
            LocalStep(name: "Cook the sauce", desc: "Let it simmer for 3 mintues", time: 4, imageUrl: "melanzana", ingredients: [
                LocalIngredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                LocalIngredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                LocalIngredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
                ]),
            LocalStep(name: "Let rest for 4 minutes", desc: "", time: 4, imageUrl: "melanzana", ingredients: [])
            ], ingredients: [
                LocalIngredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                LocalIngredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                LocalIngredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
            ]
        ),
        LocalRecipe(id: 4, name: "Melanzana", desc: "I have a View which has two labels and a Table View inside it. I want label 1 to always stay above my Table View and label 2, to be below the Table View. The problem is that the Table View needs to auto-size meaning either increase in height or decrease.Right now I have a constraint saying the Table View's height is always equal to 85 and a @IBOutlet to the height constraint where i'm able to change the constant.", rating: 3.0, imageUrl: "melanzana", time: 20, calories: 367, servings: 4, steps: [
            LocalStep(name: "Prepare tatatata", desc: "", time: 0, imageUrl: "melanzana", ingredients: []),
            LocalStep(name: "Cook the sauce", desc: "Let it simmer for 3 mintues", time: 4, imageUrl: "melanzana", ingredients: [
                LocalIngredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                LocalIngredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                LocalIngredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
                ]),
            LocalStep(name: "Let rest for 4 minutes", desc: "", time: 4, imageUrl: "melanzana", ingredients: [])
            ], ingredients: [
                LocalIngredient(id: 1, name: "Tomato", quantity: 2, unit: "cans"),
                LocalIngredient(id: 2, name: "Oil", quantity: 100, unit: "ml"),
                LocalIngredient(id: 3, name: "Garlic", quantity: 2, unit: "cloves")
            ]
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecipeService.getInstance().addToViewsCount(recipeId: (recipe?.id)!, sucessCompletionHandler: nil)
        getRecipeIngredients()
        recipeRatingInput.didFinishTouchingCosmos = { rating in
            if self.recipeRatingInput.settings.updateOnTouch {
                self.toAddExperience(rating: rating)
            }
        }
        initMargin()
        UserService.getInstance().getUser(id: (recipe?.userId)!, completionHandler: { user in
            self.user = user
            self.checkIfFavorite()
            self.initView()
        })
        stepsTableView.rowHeight = UITableView.automaticDimension
        stepsTableView.estimatedRowHeight = 140
        
        stepsTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        experiencesCollectionView.isPagingEnabled = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        stepsTableView.layer.removeAllAnimations()
        stepsTableViewHeightConstraint.constant = stepsTableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
            self.loadViewIfNeeded()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tapDetected()
        ExperienceService.getInstance().getRecipeExperience(recipeID: (recipe?.id)!, completionHandler: {experiences in
            self.experiences = experiences
            let exp = experiences.first(where: { $0.user?.id == self.appDelegate.user?.id})
            if exp != nil {
                self.recipeRatingInput.rating = Double((exp?.rating)!)
                self.recipeRatingInput.settings.updateOnTouch = false
            }else{
                self.recipeRatingInput.rating = 0
                self.recipeRatingInput.settings.updateOnTouch = true
            }
            self.experiencesCollectionView.reloadData()
            self.experiencesPageController.numberOfPages = experiences.count
        })
    }
    
    func toAddExperience(rating: Double) {
        performSegue(withIdentifier: "toAddExperience", sender: rating)
    }
    
    func getRecipeIngredients(){
        for step in (recipe?.steps)! {
            ingredients += step.ingredients!
        }
    }
    
    func initView() {
        ratingView.settings.emptyBorderColor = UIColor.clear
        recipeRatingInput.settings.fillMode = .half
        ratingView.settings.updateOnTouch = false
        //Need to send non nil rating, take recipe from web service
        ratingView.rating = Double(recipe!.rating!)
        recipeNameLabel.text = recipe!.name
        ingredientsValueLabel.text = String(ingredients.count)
        caloriesValueLabel.text = String((recipe!.calories)!)
        servingsValueLabel.text = String((recipe!.servings)!)
        timeValueLabel.text = String((recipe!.time)!)
        recipeCoverIV.af_setImage(withURL: URL(string: Constants.URL.imagesFolder+recipe!.imageUrl!)!)
        recipeDescriptionTextView.text = recipe?.description
        
        ingredientsTableViewConstraint.constant = CGFloat(44 * ingredients.count)
        recipeDescriptionTextView.sizeToFit()
        recipeDescriptionTextView.isScrollEnabled = false
        
        recipeOwnerView.layer.cornerRadius = 5
        recipeOwnerView.layer.masksToBounds = true
        
        recipeOwnerProfileImageView.layer.borderWidth = 2
        recipeOwnerProfileImageView.layer.borderColor = UIColor.white.cgColor
        recipeOwnerProfileImageView.layer.cornerRadius = recipeOwnerProfileImageView.frame.height / 2
        recipeOwnerProfileImageView.layer.masksToBounds = true
        
        recipeOwnerProfileImageShadowView.layer.cornerRadius = recipeOwnerProfileImageView.frame.height / 2
        recipeOwnerProfileImageShadowView.layer.shadowColor = UIColor.black.cgColor
        recipeOwnerProfileImageShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        recipeOwnerProfileImageShadowView.layer.shadowOpacity = 1
        
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("tapDetected"))
        recipeOwnerProfileImageView.isUserInteractionEnabled = true
        recipeOwnerProfileImageView.addGestureRecognizer(singleTap)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        initPosition = recipeOwnerView.center.x*1.1
        
        recipeOwnerProfileImageView.af_setImage(withURL: URL(string: (user?.imageUrl)!)!)
        recipeOwnerNameLabel.text = user?.username
        recipeOwnerDateLabel.text = dateFormatter.string(from: (user?.date)!)
        if self.user?.id == appDelegate.user?.id {
            visitProfileButton.isHidden = true
        }
    }
    
    var isExpanded: CGFloat = 1
    var initPosition: CGFloat?
    //Action
    @objc func tapDetected() {
        UIView.animate(withDuration: 1, animations: {
            let viewWidth = self.recipeOwnerView.frame.width
            let imageViewWidth = self.recipeOwnerProfileImageView.frame.width
            self.recipeOwnerView.center.x = (self.recipeOwnerView.center.x + (viewWidth * self.isExpanded)) - ((imageViewWidth * 2) * self.isExpanded)
            //self.recipeOwnerView.center.x = self.isExpanded ? self.initPosition!+self.recipeCoverIV.frame.width * 0.38 : self.initPosition!
            self.isExpanded *= -1
        })
    }
    
    func initMargin() {
        let margin = contentView.frame.width * 0.07
        
        //Recipe Name Label
        contentView.addConstraint(NSLayoutConstraint(item: recipeNameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin))
        //Recipe Rating View
        contentView.addConstraint(NSLayoutConstraint(item: ratingView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin))
        
        //Ingredient Stack View
        contentView.addConstraint(NSLayoutConstraint(item: ingredientsStack, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin/1.5))
        
        //Serving Stack View
        contentView.addConstraint(NSLayoutConstraint(item: servingsStack, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -margin/1.5))
        
        //Step Label
        contentView.addConstraint(NSLayoutConstraint(item: stepsLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin/1.2))
        
        //Ingredients Label
        contentView.addConstraint(NSLayoutConstraint(item: ingredientsLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin/1.2))
        
        //Similar recipes Label
        contentView.addConstraint(NSLayoutConstraint(item: similarRecipiesLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin))
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(tableView == stepsTableView && recipe!.steps![indexPath.row].time != 0){
            let timer = timerAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [timer])
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    func timerAction(at indexPath: IndexPath) -> UIContextualAction {
        //let step = recipe.steps[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Set timer") { (action, view, completion) in
            print("Set timer")
            completion(true)
        }
        action.image = UIImage(named: "timer")
        action.backgroundColor = UIColor.lightGray
        return action
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == stepsTableView {
            return recipe!.steps!.count
        }else{
            return ingredients.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == stepsTableView){
            let step = recipe!.steps![indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "stepCell")
            let contentView = cell?.viewWithTag(0)?.viewWithTag(1)
            let descriptionTextView = contentView?.viewWithTag(2) as! UITextView
            let stepImage = contentView?.viewWithTag(3) as! UIImageView
            let borderView = contentView?.viewWithTag(4)
            let timeLabel = contentView?.viewWithTag(5) as! UILabel
            
            if step.time != 0 {
                UIUtils.addRoudedDottedBorder(view: borderView!, color: UIColor.init(red: 221, green: 81, blue: 68))
                timeLabel.text = String((step.time)!)+"''"
            }
            
            descriptionTextView.text = step.description
            stepImage.af_setImage(withURL: URL(string: Constants.URL.imagesFolder+step.imageUrl!)!)
            if step.imageUrl == nil || step.imageUrl == "" {
                stepImage.constraints[0].constant = 0
            }
            /*let stepImageShadowView = contentView?.viewWithTag(6) as! UIView
            
            //Set Data
            nameLabel.text = String((step.time)!)
            descriptionTextView.text = step.description
            stepImage.af_setImage(withURL: URL(string: Constants.URL.imagesFolder+step.imageUrl!)!)
            //Init views
            contentView?.layer.cornerRadius = 10
            contentView?.layer.masksToBounds = true
            
            shadowView.layer.cornerRadius = 10
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            shadowView.layer.shadowOpacity = 0.5
            
            stepImage.layer.cornerRadius = 10
            stepImage.layer.masksToBounds = true
            
            stepImageShadowView.layer.cornerRadius = 10
            stepImageShadowView.layer.shadowColor = UIColor.black.cgColor
            stepImageShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
            stepImageShadowView.layer.shadowOpacity = 0.5*/
            
            descriptionTextView.sizeToFit()
            descriptionTextView.isScrollEnabled = false
            
            return cell!
        }else{
            let ingredient = ingredients[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell")
            let contentView = cell?.viewWithTag(0)
            let margin = contentView!.frame.width * 0.15
            let button = contentView?.viewWithTag(1) as! UIButton
            let nameLabel = contentView?.viewWithTag(2) as! UILabel
            let quantityLabel = contentView?.viewWithTag(3) as! UILabel
            
            contentView!.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin))
            contentView!.addConstraint(NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin*0.5))
            
            button.restorationIdentifier = String((ingredient.id)!)
            nameLabel.text = ingredient.name
            print("quantity")
            print(ingredient.quantity)
            print("unit")
            print(ingredient.unit)
            quantityLabel.text = String((ingredient.quantity)!)+" "+String((ingredient.unit)!)
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarRecipesCollectionView {
            return similarRecipes.count
        }else{
            return experiences.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == similarRecipesCollectionView{
            let similarRecipe = similarRecipes[indexPath.row]
            let cell = similarRecipesCollectionView.dequeueReusableCell(withReuseIdentifier: "similarRecipe", for: indexPath)
            cell.frame.size.height = similarRecipesCollectionView.frame.size.height
            cell.frame.size.width = similarRecipesCollectionView.frame.size.height
            
            //let contentView = cell.viewWithTag(0)
            let image = cell.viewWithTag(1) as! UIImageView
            let rating = cell.viewWithTag(2) as! CosmosView
            let nameLabel = cell.viewWithTag(3) as! UILabel
            
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            image.layer.cornerRadius = 8
            image.layer.masksToBounds = true
            
            rating.settings.updateOnTouch = false
            rating.settings.emptyBorderColor = UIColor.clear
            rating.rating = Double(similarRecipe.rating)
            nameLabel.text = similarRecipe.name
            image.image = UIImage(named: similarRecipe.imageUrl)
            return cell
        }else{
            let experience = experiences[indexPath.item]
            let cell = experiencesCollectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath)
            let contentView = cell.viewWithTag(0)
            let coverImageView = contentView?.viewWithTag(1) as! UIImageView
            let coverImageShadowView = (contentView?.viewWithTag(8))!
            let profileImageShadowView = (contentView?.viewWithTag(2))!
            let profileImageView = contentView?.viewWithTag(3) as! UIImageView
            let rating = contentView?.viewWithTag(4) as! CosmosView
            let nameLabel = contentView?.viewWithTag(5) as! UILabel
            let dateLabel = contentView?.viewWithTag(6) as! UILabel
            let commentTV = contentView?.viewWithTag(7) as! UITextView
            
            //Setting Data
            coverImageView.af_setImage(withURL: URL(string: Constants.URL.imagesFolder+experience.imageURL!)!)
            profileImageView.af_setImage(withURL: URL(string: (experience.user?.imageUrl!)!)!)
            rating.rating = Double(experience.rating!)
            nameLabel.text = experience.user?.username!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            dateLabel.text = dateFormatter.string(from: experience.date!)
            commentTV.text = experience.comment!
            
            let radius = profileImageView.frame.height / 2
            
            //ContentView Corner radius
            contentView?.layer.cornerRadius = 5
            contentView?.layer.masksToBounds = true
            
            //ProfileImage
            profileImageView.layer.borderWidth = 3
            profileImageView.layer.borderColor = UIColor.white.cgColor
            profileImageView.layer.cornerRadius = radius
            
            //ProfileImage Shadow
            profileImageShadowView.layer.cornerRadius = radius
            profileImageShadowView.layer.shadowColor = UIColor.black.cgColor
            profileImageShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
            profileImageShadowView.layer.shadowOpacity = 1
            
            
            //cell Shadow
            coverImageShadowView.layer.cornerRadius = 5
            coverImageShadowView.layer.shadowColor = UIColor.black.cgColor
            coverImageShadowView.layer.shadowOffset = CGSize(width:  0, height: 0)
            coverImageShadowView.layer.shadowOpacity = 1
            
            //Image
            coverImageView.layer.cornerRadius = 5
            coverImageView.layer.masksToBounds = true
            
            rating.settings.updateOnTouch = false
            rating.settings.emptyBorderColor = UIColor.clear
            rating.settings.fillMode = .precise
            
            commentTV.textContainer.lineFragmentPadding = 0
            commentTV.textContainerInset = .zero
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: experiencesCollectionView.bounds.width, height: experiencesCollectionView.bounds.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let collectionView = scrollView as? UICollectionView, collectionView == experiencesCollectionView {
            experiencesPageController.currentPage = Int(targetContentOffset.pointee.x / view.frame.width)
        }
    }
    
    @IBAction func addIngredientClicked(_ sender: Any) {
        let button = sender as! UIButton
        let rowNumber = Int(button.restorationIdentifier!)
        print(rowNumber)
    }

    @IBAction func addAllIngredients(_ sender: Any) {
        print("add all ingredients")
    }
    
    @IBAction func visitProfilClicked(_ sender: Any) {
        performSegue(withIdentifier: "toProfile", sender: sender)
    }
    
    //Favorite
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        if favorite != nil {
            FavoriteHelper.getInstance().removeFavoriteRecipe(favorite: favorite!, successCompletionHandler: {
                self.checkIfFavorite()
            }, errorCompletionHandler: {
                UIUtils.showErrorAlert(title: "Error", message: "An error has occured while trying to remove this recipe from your favorite list, please try again.", viewController: self)
            })
        }else{
            FavoriteHelper.getInstance().addRecipeToFavorite(userId: (appDelegate.user?.id)!, recipeId: (recipe?.id)!, successCompletionHandler: {
                self.checkIfFavorite()
            }, errorCompletionHandler: {
                UIUtils.showErrorAlert(title: "Error", message: "An error has occured while trying to add this recipe to your favorite list, please try again.", viewController: self)
            })
        }
    }
    
    func checkIfFavorite() {
        if user?.id == appDelegate.user?.id {
            self.navigationBar.rightBarButtonItem = nil
            return
        }
        FavoriteHelper.getInstance().getFavorite(userId: (appDelegate.user?.id)!, recipeId: (recipe?.id)!, successCompletionHandler: { favorite in
            self.addToFavoriteBarButton.image = UIImage(named: favorite != nil ? "favorite" : "unfavorite")
            self.favorite = favorite
        }, errorCompletionHandler: {
            UIUtils.showErrorAlert(title: "Error", message: "An error has occured while checking this recipe in your favorite list.", viewController: self)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            (segue.destination as! ProfileViewController).user = self.user
        }else if segue.identifier == "toAddExperience" {
            let destination = (segue.destination as! AddExperienceViewController)
            destination.rating = sender as! Double
            destination.recipe = self.recipe!
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
