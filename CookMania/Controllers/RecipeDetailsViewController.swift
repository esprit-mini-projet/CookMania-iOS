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
import EasyTipView
import SwiftKeychainWrapper

class RecipeDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, EasyTipViewDelegate {
    
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
    @IBOutlet weak var recipeOwnerViewExpandedConstraint: NSLayoutConstraint!
    @IBOutlet weak var addToFavoriteBarButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var experiencesPageController: ISPageControl!
    @IBOutlet weak var noExpereinceLabel: UILabel!
    @IBOutlet weak var experiencesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addIngredientsButton: UIButton!
    @IBOutlet weak var removeIngredientsButton: UIButton!
    @IBOutlet weak var rateThisRecipeLabel: UILabel!
    
    static let SEEN_RECIPE_HINTS_KEY = "recipe_hints"
    static let SEEN_TIMER_HINT_KEY = "timer_hint"
    
    var experiences = [Experience]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favorite: NSManagedObject?
    var recipe: Recipe?
    var user: User?
    var ingredients: [Ingredient] = []
    var shouldFinish = true
    
    var similarRecipes: [Recipe] = []
    var shopIngredients: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecipeService.getInstance().addToViewsCount(recipeId: (recipe?.id)!, sucessCompletionHandler: nil)
        loadExperiences()
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
        checkShopIngredients()
        //setting navigation backstack in case of coming from add recipe
        if(!shouldFinish){
            var backStack = [UIViewController]()
            backStack.append(self.navigationController!.viewControllers.first!)
            backStack.append(self.navigationController!.viewControllers.last!)
            self.navigationController?.setViewControllers(backStack, animated: false)
        }
    }
    
    func checkShopIngredients() {
        shopIngredients = ShopIngredientDao.getInstance().getIngredients(for: recipe!)
        if(shopIngredients.count == ingredients.count){
            addIngredientsButton.isHidden = true
            removeIngredientsButton.isHidden = false
        }else{
            addIngredientsButton.isHidden = false
            removeIngredientsButton.isHidden = true
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        stepsTableView.layer.removeAllAnimations()
        stepsTableViewHeightConstraint.constant = stepsTableView.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
            self.loadViewIfNeeded()
        }
    }
    
    private var tipCounter  = 0
    private var firsIngredientRowView: UIView?
    private var firstTimerCircleView: UIView?
    
    private var hintsView: [EasyTipView] = []
    
    override func viewDidAppear(_ animated: Bool) {
        tapDetected()
        RecipeService.getInstance().getSimilarRecipies(recipe: recipe!, successCompletionHandler: { recipes in
            self.similarRecipes = recipes
            self.similarRecipesCollectionView.reloadData()
        })
        loadExperiences()
        startTips()
    }
    
    func startTips() {
        if !(KeychainWrapper.standard.bool(forKey: RecipeDetailsViewController.SEEN_RECIPE_HINTS_KEY) ?? false){
            let offset = self.addIngredientsButton!.frame.origin.y - self.scrollView.bounds.size.height + (self.addIngredientsButton?.frame.size.height)!
            UIView.animate(withDuration: 0.3, animations: {
                if offset > 0 {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
                }
            }) { ( finished) in
                self.hintsView.append(EasyTipView(text: "Click this button to add/remove all recipe ingredients to/from the shopping list. Tap to see next Tip.", preferences: EasyTipView.globalPreferences, delegate: self))
                self.hintsView[self.hintsView.count-1].show(forView: self.addIngredientsButton)
                self.tipCounter+=1
            }
        }else if !(KeychainWrapper.standard.bool(forKey: RecipeDetailsViewController.SEEN_TIMER_HINT_KEY) ?? false) {
            showTimerHint()
        }
    }
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        switch tipCounter {
        case 1:
            let offset = self.firsIngredientRowView!.convert(CGPoint(x: 0, y: self.firsIngredientRowView!.frame.origin.y), to: self.view).y - self.scrollView.bounds.size.height + (self.firsIngredientRowView?.frame.size.height)!
            UIView.animate(withDuration: 0.3, animations: {
                if offset > 0 {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
                }
            }) { ( finished) in
                self.hintsView.append(EasyTipView(text: "Or swipe here to add/remove a specific ingredient to/from shopping list.", preferences: EasyTipView.globalPreferences, delegate: self))
                self.hintsView[self.hintsView.count-1].show(forView: self.firsIngredientRowView!)
                KeychainWrapper.standard.set(true, forKey: RecipeDetailsViewController.SEEN_RECIPE_HINTS_KEY)
                self.tipCounter+=1
            }
            break
        case 2:
            showTimerHint()
            break
        default:
            return
        }
    }
    
    func showTimerHint() {
        if(firstTimerCircleView != nil) {
            let offset = self.firstTimerCircleView!.convert(CGPoint(x: 0, y: self.firstTimerCircleView!.frame.origin.y), to: self.view).y - self.scrollView.bounds.size.height + (self.firstTimerCircleView?.frame.size.height)!
            UIView.animate(withDuration: 0.3, animations: {
                if offset > 0 {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
                }
            }) { ( finished) in
                self.hintsView.append(EasyTipView(text: "Tap here to activate the timer.", preferences: EasyTipView.globalPreferences, delegate: self))
                self.hintsView[self.hintsView.count-1].show(forView: self.firstTimerCircleView!)
                KeychainWrapper.standard.set(true, forKey: RecipeDetailsViewController.SEEN_TIMER_HINT_KEY)
                self.tipCounter=3
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tipCounter=3
        for hint in hintsView {
            hint.dismiss()
        }
    }
    
    func loadExperiences() {
        ExperienceService.getInstance().getRecipeExperience(recipeID: (recipe?.id)!, completionHandler: {experiences in
            self.experiences = experiences
            if self.experiences.count == 0{
                self.noExpereinceLabel.isHidden = false
                self.experiencesCollectionViewHeightConstraint.constant = 0
            }else{
                self.noExpereinceLabel.isHidden = true
                self.experiencesCollectionViewHeightConstraint.constant = 250
            }
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
            self.experiencesPageController.currentPage = 0
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
        recipeOwnerProfileImageView.layer.masksToBounds = true
        
        recipeOwnerProfileImageShadowView.layer.shadowColor = UIColor.black.cgColor
        recipeOwnerProfileImageShadowView.layer.shadowOffset = CGSize(width: 1, height: 1)
        recipeOwnerProfileImageShadowView.layer.shadowOpacity = 1
        
        
        recipeOwnerProfileImageShadowView.layer.cornerRadius = recipeOwnerProfileImageShadowView.frame.size.width / 2
        recipeOwnerProfileImageView.layer.cornerRadius = recipeOwnerProfileImageView.frame.size.width / 2
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(RecipeDetailsViewController.tapDetected))
        recipeOwnerProfileImageView.isUserInteractionEnabled = true
        recipeOwnerProfileImageView.addGestureRecognizer(singleTap)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        initPosition = recipeOwnerView.center.x*1.1
        
        let url = URL(string: (user?.imageUrl)!)
        if url != nil {
            recipeOwnerProfileImageView.af_setImage(withURL: url!)
        }
        recipeOwnerNameLabel.text = user?.username
        if(user?.id == appDelegate.user?.id){
            recipeOwnerNameLabel.textColor = UIColor.black
            recipeRatingInput.isHidden = true
            rateThisRecipeLabel.text = "Experiences"
            rateThisRecipeLabel.textColor = UIColor.black
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
            if self.isExpanded < 0 {
                self.recipeOwnerNameLabel.alpha = 1
            }else{
                self.recipeOwnerNameLabel.alpha = 0
            }
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
        print("Reloaded")
        if tableView == ingredientsTableView {
            let ing = self.ingredients[indexPath.item]
            if shopIngredients.first(where: {$0.id == ing.id}) == nil{
                let addToShoppingListAction = getAddToShoppingListAction(at: indexPath)
                return UISwipeActionsConfiguration(actions: [addToShoppingListAction])
            }else{
                let removeFromShoppingListAction = getDeleteFromShoppingListAction(at: indexPath)
                return UISwipeActionsConfiguration(actions: [removeFromShoppingListAction])
            }
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    func getAddToShoppingListAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            let ingredient = self.ingredients[indexPath.item]
            print("Clicked: "+ingredient.name!)
            ShopIngredientDao.getInstance().add(ingredient: ingredient, recipe: self.recipe!, completionHandler: {bool in
                self.checkShopIngredients()
                self.ingredientsTableView.reloadRows(at: [indexPath], with: .automatic)
                completion(true)
            })
        }
        action.image = UIImage(named: "add-icon2")
        action.backgroundColor = UIColor.init(rgb: 0x477998)
        return action
    }
    
    func getDeleteFromShoppingListAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            let ingredient = self.ingredients[indexPath.item]
            print("Clicked: "+ingredient.name!)
            ShopIngredientDao.getInstance().delete(ingredientId: ingredient.id!, completionHandler: {
                self.checkShopIngredients()
                self.ingredientsTableView.reloadRows(at: [indexPath], with: .automatic)
                completion(true)
            })
        }
        action.image = UIImage(named: "remove_ingredient")
        action.backgroundColor = UIColor.init(rgb: 0xE32929)
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
            let timeLabel = contentView?.viewWithTag(5) as! UIButton
            
            if step.time != 0 {
                UIUtils.addRoudedDottedBorder(view: borderView!, color: UIColor.init(red: 221, green: 81, blue: 68))
                timeLabel.setTitle(String((step.time)!)+"''", for: .normal)
                if(self.firstTimerCircleView == nil){
                    firstTimerCircleView = borderView
                }
            }
            
            descriptionTextView.text = step.description
            stepImage.af_setImage(withURL: URL(string: Constants.URL.imagesFolder+step.imageUrl!)!)
            if step.imageUrl == nil || step.imageUrl == "" {
                stepImage.constraints[0].constant = 0
            }
            
            descriptionTextView.sizeToFit()
            descriptionTextView.isScrollEnabled = false
            
            return cell!
        }else{
            let ingredient = ingredients[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell")
            let contentView = cell?.viewWithTag(0)
            let nameLabel = contentView?.viewWithTag(2) as! UILabel
            let quantityLabel = contentView?.viewWithTag(3) as! UILabel
            
            if(indexPath.row == 0) {
                firsIngredientRowView = contentView
            }
            
            /*contentView!.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: margin))*/
            
            nameLabel.text = ingredient.name
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
            
            let image = cell.viewWithTag(1) as! UIImageView
            let rating = cell.viewWithTag(2) as! CosmosView
            let nameLabel = cell.viewWithTag(3) as! UILabel
            let contentView = cell.viewWithTag(5)
            let shadowView = cell.viewWithTag(4)
            
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            contentView?.layer.cornerRadius = 8
            contentView?.layer.masksToBounds = true
            
            shadowView!.layer.cornerRadius = 8
            shadowView!.layer.shadowColor = UIColor.black.cgColor
            shadowView!.layer.shadowOffset = CGSize(width: 1, height: 1)
            shadowView!.layer.shadowOpacity = 0.5
            
            rating.settings.updateOnTouch = false
            rating.rating = Double(similarRecipe.rating!)
            nameLabel.text = similarRecipe.name
            image.af_setImage(withURL: URL(string: Constants.URL.imagesFolder+similarRecipe.imageUrl!)!)
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
            let removeButton = contentView?.viewWithTag(9) as! UIButton
            
            if experience.user?.id == appDelegate.user?.id {
                removeButton.isHidden = false
            }
            
            //Setting Data
            let experienceUrl = URL(string: Constants.URL.imagesFolder+experience.imageURL!)
            if experienceUrl != nil {
                coverImageView.af_setImage(withURL: experienceUrl!)
            }
            let userImageUrl = URL(string: (experience.user?.imageUrl!)!)
            if userImageUrl != nil {
                profileImageView.af_setImage(withURL: userImageUrl!)
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarRecipesCollectionView {
            RecipeService.getInstance().getRecipe(recipeId: similarRecipes[indexPath.item].id!, completionHandler: { recip in
                self.performSegue(withIdentifier: "toDetails", sender: recip)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == experiencesCollectionView {
            return CGSize(width: experiencesCollectionView.bounds.width, height: experiencesCollectionView.bounds.height)
        }else{
            return CGSize(width: similarRecipesCollectionView.bounds.width * 0.53, height: similarRecipesCollectionView.bounds.height)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let collectionView = scrollView as? UICollectionView, collectionView == experiencesCollectionView {
            experiencesPageController.currentPage = Int(targetContentOffset.pointee.x / view.frame.width)
        }
    }

    @IBAction func addAllIngredients(_ sender: Any) {
        print("add all ingredients")
        ShopRecipeDao.getInstance().add(recipe: self.recipe!) { (success) in
            if success{
                print("success")
                self.checkShopIngredients()
                self.ingredientsTableView.reloadData()
            }else{
                print("failure")
            }
        }
    }
    
    @IBAction func removeAllIngredients(_ sender: Any) {
        print("remove all ingredients")
        ShopRecipeDao.getInstance().delete(recipeId: (self.recipe?.id)!, completionHandler: {
            print("success")
            self.checkShopIngredients()
            self.ingredientsTableView.reloadData()
        })
    }
    
    @IBAction func visitProfilClicked(_ sender: Any) {
        if self.user?.id == appDelegate.user?.id {
            return
        }
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
    
    @IBAction func timerTapped(_ sender: Any) {
        if let labelText = (sender as! UIButton).titleLabel?.text {
            let index = labelText.index(labelText.endIndex, offsetBy: -2)
            let timeText = labelText[..<index]
            performSegue(withIdentifier: "toTimer", sender: Int(timeText))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfile" {
            print(self.user?.username)
            (segue.destination as! OthersProfileViewController).user = self.user
        }else if segue.identifier == "toAddExperience" {
            let destination = (segue.destination as! AddExperienceViewController)
            destination.rating = (sender as! Double)
            destination.recipe = self.recipe!
        }else if segue.identifier == "toTimer" {
            let destination = (segue.destination as! TimerViewController)
            destination.time = (sender as! Int)
        }else if segue.identifier == "toDetails" {
            let destination = (segue.destination as! RecipeDetailsViewController)
            destination.recipe = (sender as! Recipe)
        }
    }
    
    @IBAction func removeExperience(_ sender: Any) {
        let alert = UIAlertController(title: "Confirmation", message: "So yout want to delete this experience?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            ExperienceService.getInstance().removeExperience(userId: (self.appDelegate.user?.id)!, recipeId: (self.recipe?.id)!, sucessCompletionHandler: {
                self.loadExperiences()
            }, errorCompletionHandler: {
                UIUtils.showErrorAlert(viewController: self)
            })
        }))
        present(alert, animated: true, completion: nil)
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
