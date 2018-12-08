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
    
    func createRecipe(recipe: Recipe, recipeImage: UIImage, images: [UIImage?], completionHandler: @escaping (Bool) -> ()) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(recipeImage.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "send.png", mimeType: "image/png")
            multipartFormData.append((recipe.userId)!.data(using: .utf8)!, withName: "user_id", mimeType: "text/plain")
            multipartFormData.append((recipe.name)!.data(using: .utf8)!, withName: "name", mimeType: "text/plain")
            multipartFormData.append((recipe.description)!.data(using: .utf8)!, withName: "description", mimeType: "text/plain")
            multipartFormData.append(String(recipe.calories!).data(using: .utf8)!, withName: "calories", mimeType: "text/plain")
            multipartFormData.append(String(recipe.time!).data(using: .utf8)!, withName: "time", mimeType: "text/plain")
            multipartFormData.append(String(recipe.servings!).data(using: .utf8)!, withName: "servings", mimeType: "text/plain")
            
            let labelsData = try! JSONSerialization.data(withJSONObject: recipe.labels!, options: [])
            let labelsJsonString = String(data: labelsData, encoding: .utf8)!
            multipartFormData.append(labelsJsonString.data(using: .utf8)!, withName: "labels")
            
        }, to:ServiceUtils.buildURL(route: ROUTE, postfix: "add")){ (result) in
            switch result {
            case .success( let upload, _, _):
                upload.responseString(completionHandler: { (response) in
                    if response.response?.statusCode == 200 {
                        let json = JSON(parseJSON: response.result.value!)
                        let recipeId = json["id"].intValue
                        self.addSteps(recipeId: recipeId, steps: recipe.steps!, images: images, completionHandler: { (isSuccess) in
                            completionHandler(isSuccess)
                        })
                    }else{
                        completionHandler(false)
                    }
                })
            case .failure(let encodingError):
                print("",encodingError.localizedDescription)
                break
            }
        }
    }
    
    //Recursive call to chain requests and make a callback at the end
    func addSteps(recipeId: Int, steps: [Step], images: [UIImage?], completionHandler: @escaping (Bool) -> ()){
        if steps.isEmpty {
            completionHandler(true)
            return
        }
        var s = steps
        var i = images
        let step = s.removeFirst()
        let image = i.removeFirst()
        addSingleStep(recipeId: recipeId, step: step, image: image, completionHandler: { (isSuccess) in
            if isSuccess {
                self.addSteps(recipeId: recipeId, steps: s, images: i, completionHandler: completionHandler)
            }else {
                completionHandler(false)
            }
        })
    }
    
    func addSingleStep(recipeId: Int, step: Step, image: UIImage?, completionHandler: @escaping (Bool) -> ()){
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let _ = image {
                multipartFormData.append(image!.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "send.png", mimeType: "image/png")
            }
            multipartFormData.append(String(recipeId).data(using: .utf8)!, withName: "recipe_id", mimeType: "text/plain")
            multipartFormData.append((step.description)!.data(using: .utf8)!, withName: "description", mimeType: "text/plain")
            multipartFormData.append(String(step.time!).data(using: .utf8)!, withName: "time", mimeType: "text/plain")
            
            let ingredientsJsonString = step.ingredients?.toJSONString(prettyPrint: false)
            multipartFormData.append(ingredientsJsonString!.data(using: .utf8)!, withName: "ingredients")
            
        }, to:ServiceUtils.buildURL(route: "/steps", postfix: "add")){ (result) in
            switch result {
            case .success( let upload, _, _):
                upload.responseString(completionHandler: { (response) in
                    completionHandler(response.response?.statusCode == 200)
                })
            case .failure(let encodingError):
                print("",encodingError.localizedDescription)
                break
            }
        }
    }
}
