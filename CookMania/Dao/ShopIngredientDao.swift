//
//  ShopIngredientDao.swift
//  CookMania
//
//  Created by Elyes on 12/19/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//
import Foundation
import CoreStore

class ShopIngredientDao: NSObject{
    private static var instance: ShopIngredientDao?
    
    private override init() {
        
    }
    
    public static func getInstance() -> ShopIngredientDao{
        if(instance == nil){
            instance = ShopIngredientDao()
        }
        return instance!
    }
    
    public func getIngredients() -> [ShopIngredient] {
        let userId = (UIApplication.shared.delegate as! AppDelegate).user?.id
        return CoreStore.fetchAll(From<ShopIngredient>().where(format: "userId == %@", userId!))!
    }
    
    public func add(ingredient: Ingredient, recipe: Recipe, completionHandler: @escaping (Bool) -> ()){
        let userId = (UIApplication.shared.delegate as! AppDelegate).user?.id
        CoreStore.perform(asynchronous: { (transaction) -> Void in
            let ing: ShopIngredient = transaction.create(Into<ShopIngredient>())
            ing.name = ingredient.name
            ing.id = Int32(String(ingredient.id!))!
            ing.quantity = Int32(String(ingredient.quantity!))!
            ing.unit = ingredient.unit
            
            if let r = CoreStore.fetchOne(From<ShopRecipe>().where(format: "id == %d AND userId == %@", recipe.id!, userId!)){
                ing.recipe = r
            }else{
                let r: ShopRecipe = transaction.create(Into<ShopRecipe>())
                r.name = recipe.name
                r.id = Int32(String(recipe.id!))!
                r.imageUrl = recipe.imageUrl
                r.userId = userId
                r.addToIngredients(ing)
            }
        }) { (result) in
            switch result{
            case .success:
                print("success")
                completionHandler(true)
            case .failure:
                print("failure")
                completionHandler(false)
            }
        }
    }
    
    public func delete(ingredientId: Int, completionHandler: @escaping () -> ()){
        let ing = CoreStore.fetchOne(From<ShopIngredient>().where(format: "id == %d", ingredientId))
        let recipeId = Int(String(ing!.recipe!.id))!
        CoreStore.perform(
            asynchronous: { (transaction) -> Void in
                transaction.delete(ing)
            },
                completion: { _ in
                    ShopRecipeDao.getInstance().delete(recipeId: recipeId, completionHandler: {
                        completionHandler()
                    })
            }
        )
    }
}
