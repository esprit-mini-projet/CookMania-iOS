//
//  FavoriteHelpe.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/28/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import CoreData

class FavoriteHelper: NSObject {
    private static var instance: FavoriteHelper?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private override init() {}
    
    public static func getInstance() -> FavoriteHelper{
        if(instance == nil){
            instance = FavoriteHelper()
        }
        return instance!
    }
    
    func getFavoriteRecipes(userId: String, completionHandler: @escaping (_ recipes: [Recipe]) -> ()) {
        let persistance = appDelegate.persistentContainer
        let context = persistance.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        do {
            let results = try context.fetch(request)
            var recipes: [Recipe] = []
            if results.count == 0 {
                completionHandler(recipes)
                return
            }
            for result in results {
                let recipeId = result.value(forKey: "recipeId") as! Int
                RecipeService.getInstance().getRecipe(recipeId: recipeId, completionHandler: { recipe in
                    recipes.append(recipe)
                    if recipes.count == results.count {
                        completionHandler(recipes)
                        return
                    }
                })
            }
        } catch  {
            print("error")
        }
    }
    
    func getFavorite(userId: String, recipeId: Int, successCompletionHandler: @escaping (_ favorite: NSManagedObject?) -> (), errorCompletionHandler: @escaping () -> ()) {
        let persistance = appDelegate.persistentContainer
        let context = persistance.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "recipeId == %d AND userId == %@", recipeId, userId)
        do {
            let result = try context.fetch(request)
            if(result.count != 0){
                successCompletionHandler(result[0])
            }else{
                successCompletionHandler(nil)
            }
        } catch  {
            errorCompletionHandler()
        }
    }
    
    func removeFavoriteRecipe(favorite: NSManagedObject, successCompletionHandler: @escaping () -> (), errorCompletionHandler: @escaping () -> ()) {
        let persistanceContainer = appDelegate.persistentContainer
        let managedContext = persistanceContainer.viewContext
        managedContext.delete(favorite)
        do{
            try managedContext.save()
            successCompletionHandler()
        }catch{
            errorCompletionHandler()
        }
    }
    
    func addRecipeToFavorite(userId: String, recipeId: Int, successCompletionHandler: @escaping () -> (), errorCompletionHandler: @escaping () -> ()) {
        let persistantContainer = appDelegate.persistentContainer
        let managedContext = persistantContainer.viewContext
        let favoriteDesc = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext)
        let favorite = NSManagedObject(entity: favoriteDesc!, insertInto: managedContext)
        favorite.setValue(recipeId, forKey: "recipeId")
        favorite.setValue(userId, forKey: "userId")
        favorite.setValue(Date(), forKey: "date")
        do{
            try managedContext.save()
            successCompletionHandler()
        } catch {
            errorCompletionHandler()
        }
    }
}
