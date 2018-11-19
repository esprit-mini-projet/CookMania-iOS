//
//  RecipeService.swift
//  CookMania
//
//  Created by Elyes on 11/16/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

public class RecipeService: NSObject{
    private let ROUTE = "/recipes"
    
    private static var instance: RecipeService?
    
    private override init() {}
    
    public static func getInstance() -> RecipeService{
        if(instance == nil){
            instance = RecipeService()
        }
        return instance!
    }
    
    func buildURL(postfix: String) -> String {
        return AppDelegate.SERVER_DOMAIN + ROUTE + "/" + postfix
    }
    
    func getRecipe(recipeId: Int, completionHandler: @escaping (_ recipe: Recipe) -> ()){
        Alamofire.request(buildURL(postfix: String(recipeId)))
            .responseString(completionHandler: { (response: DataResponse<String>) in
                let recipe = Mapper<Recipe>().map(JSONString: response.result.value!)!
                completionHandler(recipe)
        })
    }
    
    func getRecipes(completionHandler: @escaping (_ recipes: [Recipe]) -> ()){
        Alamofire.request(buildURL(postfix: ""))
            .responseString(completionHandler: { (response: DataResponse<String>) in
                let recipes = Mapper<Recipe>().mapArray(JSONString: response.result.value!)!
                completionHandler(recipes)
        })
    }
    
    func getTopRecipes(completionHandler: @escaping (_ recipes: [Recipe]) -> ()){
        Alamofire.request(buildURL(postfix: "top"))
            .responseString(completionHandler: { (response: DataResponse<String>) in
                let recipes = Mapper<Recipe>().mapArray(JSONString: response.result.value!)!
                completionHandler(recipes)
            })
    }
    
    func getRecipesByLabel(label: String, completionHandler: @escaping (_ recipes: [Recipe]) -> ()){
        Alamofire.request(buildURL(postfix: "label/" + label))
            .responseString(completionHandler: { (response: DataResponse<String>) in
                let recipes = Mapper<Recipe>().mapArray(JSONString: response.result.value!)!
                completionHandler(recipes)
            })
    }
}
