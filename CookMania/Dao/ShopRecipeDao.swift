//
//  ShopRecipeDao.swift
//  CookMania
//
//  Created by Elyes on 12/12/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import CoreStore
import SwiftKeychainWrapper
import AlamofireImage

class ShopRecipeDao: NSObject{
    private static var instance: ShopRecipeDao?
    
    private override init() {
        
    }
    
    public static func getInstance() -> ShopRecipeDao{
        if(instance == nil){
            instance = ShopRecipeDao()
        }
        return instance!
    }
    
    public func getRecipes() -> [ShopRecipe] {
        let userId = KeychainWrapper.standard.string(forKey: "cookmania_user_id")!
        return CoreStore.fetchAll(From<ShopRecipe>().where(format: "userId == %@", userId))!
    }
    
    public func add(recipe: Recipe, completionHandler: @escaping (Bool) -> ()){
        let userId = KeychainWrapper.standard.string(forKey: "cookmania_user_id")!
        UIUtils.downloadImage(url: URL(string: Constants.URL.imagesFolder + recipe.imageUrl!)!) { (image, error) in
            if error == nil {
                CoreStore.perform(asynchronous: { (transaction) -> Void in
                    var r: ShopRecipe
                    if let rec = transaction.fetchOne(From<ShopRecipe>().where(format: "id == %d AND userId == %@", recipe.id!, userId)){
                        r = rec
                    }else{
                        r = transaction.create(Into<ShopRecipe>())
                        r.name = recipe.name
                        r.id = Int32(String(recipe.id!))!
                        r.imageUrl = recipe.imageUrl
                        r.userId = userId
                    }
                    for ingredient in recipe.getIngredients(){
                        if let _ = transaction.fetchOne(From<ShopIngredient>().where(format: "id == %d", ingredient.id!)){
                            continue
                        }
                        let ing: ShopIngredient = transaction.create(Into<ShopIngredient>())
                        ing.id = Int32(String(ingredient.id!))!
                        ing.name = ingredient.name
                        ing.quantity = Int32(String(ingredient.quantity!))!
                        ing.unit = ingredient.unit
                        ing.userId = userId
                        ing.recipe = r
                    }
                }) { (result) in
                    switch result{
                    case .success:
                        completionHandler(true)
                    case .failure:
                        completionHandler(false)
                    }
                }
            }
        }
    }
    
    public func delete(recipeId: Int, completionHandler: @escaping () -> ()){
        let userId = KeychainWrapper.standard.string(forKey: "cookmania_user_id")!
        CoreStore.perform(asynchronous: { (transaction) -> Int? in
            let recipe = transaction.fetchOne(From<ShopRecipe>().where(format: "id == %d AND userId == %@", recipeId, userId))
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = "\(documentPath)" + (recipe!.imageUrl)!
            do {
                try FileManager.default.removeItem(at: URL(string: filePath)!)
            } catch {
                print("Error deleting image")
            }
            return transaction.deleteAll(
                From<ShopRecipe>().where(format: "id == %d AND userId == %@", argumentArray: [recipeId, userId])
            )
        },
            completion: { _ in
                completionHandler()
                
            }
        )
    }
    
    public func deleteAll(completionHandler: @escaping () -> ()){
        let userId = KeychainWrapper.standard.string(forKey: "cookmania_user_id")!
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        for shopRecipe in self.getRecipes() {
            let filePath = "\(documentPath)" + (shopRecipe.imageUrl)!
            do {
                try FileManager.default.removeItem(at: URL(string: filePath)!)
            } catch {
                print("Error deleting image")
            }
        }
        CoreStore.perform(
            asynchronous: { (transaction) -> Int? in
                transaction.deleteAll(
                    From<ShopRecipe>().where(format: "userId == %@", argumentArray: [userId])
                )
        },
            completion: { _ in
                completionHandler()
            }
        )
    }
}
