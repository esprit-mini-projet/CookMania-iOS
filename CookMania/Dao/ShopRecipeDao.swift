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
        CoreStore.defaultStack = DataStack(xcodeModelName: "CookMania")
    }
    
    public static func getInstance() -> ShopRecipeDao{
        if(instance == nil){
            instance = ShopRecipeDao()
        }
        return instance!
    }
    
    public func getRecipes(forUser userId: String) -> [ShopRecipe] {
        return CoreStore.fetchAll(From<ShopRecipe>().where(format: "userId == %@", userId))!
    }
    
    public func add(recipe: ShopRecipe, completionHandler: @escaping (Bool) -> ()){
        CoreStore.perform(asynchronous: { (transaction) -> Void in
            let r: ShopRecipe = transaction.create(Into<ShopRecipe>())
            r.name = recipe.name
            r.id = recipe.id
            r.imageUrl = recipe.imageUrl
            r.addToIngredients(recipe.ingredients!)
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
}
