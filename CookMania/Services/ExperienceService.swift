//
//  ExperienceService.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/15/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ExperienceService: NSObject {
    private let ROUTE = "/experiences"
    
    private static var instance: ExperienceService?
    
    private override init() {}
    
    public static func getInstance() -> ExperienceService{
        if(instance == nil){
            instance = ExperienceService()
        }
        return instance!
    }
    
    func getRecipeExperience(recipeID: Int, completionHandler: @escaping (_ experience: [Experience]) -> ()){
        Loader.getInstance().startLoader()
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "recipe/"+String(recipeID))).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                let experiences: [Experience] = Mapper<Experience>().mapArray(JSONString: response.result.value!)!
                completionHandler(experiences)
                Loader.getInstance().stopLoader()
                break
            case .failure(let error):
                print(error)
                Loader.getInstance().stopLoader()
                break
            }
        })
    }
    
    func addRecipeExperience(experience: Experience, image: UIImage, recipeId: Int, ownerId: String, completionHandler: @escaping () -> ()) {
        Loader.getInstance().startLoader()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "send.png", mimeType: "image/jpg")
            multipartFormData.append((experience.user?.id)!.data(using: .utf8)!, withName: "user_id", mimeType: "text/plain")
            multipartFormData.append(String(recipeId).data(using: .utf8)!, withName: "recipe_id", mimeType: "text/plain")
            multipartFormData.append(ownerId.data(using: .utf8)!, withName: "owner_id", mimeType: "text/plain")
            multipartFormData.append(String(experience.rating!).data(using: .utf8)!, withName: "rating", mimeType: "text/plain")
            multipartFormData.append(String(experience.comment!).data(using: .utf8)!, withName: "comment", mimeType: "text/plain")
        }, to:ServiceUtils.buildURL(route: ROUTE, postfix: "add")){ (result) in
            switch result {
            case .success( _, _, _):
                    completionHandler()
                    Loader.getInstance().stopLoader()
                case .failure(let encodingError):
                    print("",encodingError.localizedDescription)
                    Loader.getInstance().stopLoader()
                    break
            }
        }
    }
    
    func removeExperience(userId: String, recipeId: Int, sucessCompletionHandler: @escaping () -> (), errorCompletionHandler: @escaping () -> ()) {
        Loader.getInstance().startLoader()
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "remove/"+userId+"/"+String(recipeId)), method: .delete).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                sucessCompletionHandler()
                Loader.getInstance().stopLoader()
                break
            case .failure( _):
                errorCompletionHandler()
                Loader.getInstance().stopLoader()
                break
            }
        })
    }
}
