//
//  ShopRecipeDao.swift
//  CookMania
//
//  Created by Elyes on 12/12/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import CoreStore

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
        let userId = (UIApplication.shared.delegate as! AppDelegate).user?.id
        return CoreStore.fetchAll(From<ShopRecipe>().where(format: "userId == %@", userId!))!
    }
    
    public func add(recipe: Recipe, completionHandler: @escaping (Bool) -> ()){
        let userId = (UIApplication.shared.delegate as! AppDelegate).user?.id
        CoreStore.perform(asynchronous: { (transaction) -> Void in
            let r: ShopRecipe = transaction.create(Into<ShopRecipe>())
            r.name = recipe.name
            r.id = Int32(String(recipe.id!))!
            r.imageUrl = recipe.imageUrl
            r.userId = userId
            for ingredient in recipe.getIngredients(){
                if let _ = CoreStore.fetchOne(From<ShopIngredient>().where(format: "id == %d", ingredient.id!)){
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
    
    public func delete(recipeId: Int, completionHandler: @escaping () -> ()){
        let userId = (UIApplication.shared.delegate as! AppDelegate).user?.id
        CoreStore.perform(
            asynchronous: { (transaction) -> Int? in
                transaction.deleteAll(
                    From<ShopRecipe>().where(format: "id == %d AND userId == %@", argumentArray: [recipeId, userId!])
                )
            },
                completion: { _ in
                    completionHandler()
            }
        )
    }
    
    public func deleteAll(completionHandler: @escaping () -> ()){
        let userId = (UIApplication.shared.delegate as! AppDelegate).user?.id
        CoreStore.perform(
            asynchronous: { (transaction) -> Int? in
                transaction.deleteAll(
                    From<ShopRecipe>().where(format: "userId == %@", argumentArray: [userId!])
                )
            },
                completion: { _ in
                    completionHandler()
            }
        )
    }
}
