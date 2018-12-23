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
            
            if let r = transaction.fetchOne(From<ShopRecipe>().where(format: "id == %d AND userId == %@", recipe.id!, userId!)){
                r.addToIngredients(ing)
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
                completionHandler(true)
            case .failure:
                completionHandler(false)
            }
        }
    }
    
    public func delete(ingredientId: Int, completionHandler: @escaping () -> ()){
        let ing = CoreStore.fetchOne(From<ShopIngredient>().where(format: "id == %d", ingredientId))
        let recipe = ing!.recipe
        let count = recipe!.ingredients?.count
        CoreStore.perform(
            asynchronous: { (transaction) -> Void in
                transaction.delete(ing)
            },
                completion: { _ in
                    if count == 1{
                        ShopRecipeDao.getInstance().delete(recipeId: Int(String(recipe!.id))!, completionHandler: {
                            completionHandler()
                        })
                    }else{
                        completionHandler()
                    }
            }
        )
    }
    
    public func updateChecked(ingredient: ShopIngredient, checked: Bool,  completionHandler: @escaping () -> ()){
        CoreStore.perform(
            asynchronous: { (transaction) -> Void in
                let ing = transaction.edit(ingredient)
                ing?.checked = checked
            },
                completion: { _ in
                    
            }
        )
    }
}