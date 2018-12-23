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
import SwiftyJSON

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
    
    func getRecipeSuggestions(completionHandler: @escaping (_ title: String, _ recipes: [Recipe]) -> ()){
        Alamofire.request(buildURL(postfix: "suggestions"))
            .responseString(completionHandler: { (response: DataResponse<String>) in
                let json = JSON(parseJSON: response.result.value!)
                let title = json["title"].stringValue
                let recipes = Mapper<Recipe>().mapArray(JSONString: json["recipes"].rawString()!)
                completionHandler(title, recipes!)
            })
    }
    
    func deleteRecipe(recipeId: Int, sucessCompletionHandler: @escaping () -> (), errorCompletionHandler: @escaping () -> ()) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: String(recipeId)), method: .delete).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                sucessCompletionHandler()
                break
            case .failure( _):
                errorCompletionHandler()
                break
            }
        })
    }
    
    //add 1 to recipe's favorites count
    func addToFavoritesCount(recipeId: Int, sucessCompletionHandler: @escaping () -> ()) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "addFavorites/"+String(recipeId)), method: .put).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                sucessCompletionHandler()
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    //remove 1 from recipe's favorites count
    func removeFromFavoritesCount(recipeId: Int, sucessCompletionHandler: @escaping () -> ()) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "removeFavorites/"+String(recipeId)), method: .put).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                sucessCompletionHandler()
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    //add 1 to recipe's views count
    func addToViewsCount(recipeId: Int, sucessCompletionHandler: (() -> ())?) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "addViews/"+String(recipeId)), method: .put).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                sucessCompletionHandler?()
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func getSimilarRecipies(recipe: Recipe, successCompletionHandler: @escaping ((_ recipies: [Recipe]) -> ())) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "similar"), method: .post, parameters: ["labels": recipe.labels!.description, "recipe_id": recipe.id!],encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
                case .success:
                    let json = JSON(parseJSON: response.result.value!)
                    let recipes = Mapper<Recipe>().mapArray(JSONString: json.rawString()!)
                    successCompletionHandler(recipes!)
                    break
                case .failure(let error):
                    print(error)
                    break
            }
        })
    }
}
