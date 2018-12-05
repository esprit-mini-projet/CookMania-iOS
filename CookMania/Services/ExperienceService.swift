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
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "recipe/"+String(recipeID))).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                let experiences: [Experience] = Mapper<Experience>().mapArray(JSONString: response.result.value!)!
                completionHandler(experiences)
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func addRecipeExperience(experience: Experience, image: UIImage, recipeId: Int, completionHandler: @escaping () -> ()) {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "send.png", mimeType: "image/jpg")
            multipartFormData.append((experience.user?.id)!.data(using: .utf8)!, withName: "user_id", mimeType: "text/plain")
            multipartFormData.append(String(recipeId).data(using: .utf8)!, withName: "recipe_id", mimeType: "text/plain")
            multipartFormData.append(String(experience.rating!).data(using: .utf8)!, withName: "rating", mimeType: "text/plain")
            multipartFormData.append(String(experience.comment!).data(using: .utf8)!, withName: "comment", mimeType: "text/plain")
        }, to:ServiceUtils.buildURL(route: ROUTE, postfix: "add")){ (result) in
            switch result {
            case .success( _, _, _):
                    completionHandler()
                case .failure(let encodingError):
                    print("",encodingError.localizedDescription)
                    break
            }
        }
        
        /*Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.accessibilityIdentifier, withName: "image")
        }, to: ServiceUtils.buildURL(route: ROUTE, postfix: "add"), encodingCompletion: { (encodingResult) in
            switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { request, response, JSON, error in
                    
                    }
                case .Failure(let encodingError): break
            }
        })*/
        
       /*Alamofire.upload(
            .POST,
            URLString: ServiceUtils.buildURL(route: ROUTE, postfix: "add"), // http://httpbin.org/post
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: imagePathUrl!, name: "photo")
                multipartFormData.appendBodyPart(fileURL: videoPathUrl!, name: "video")
                multipartFormData.appendBodyPart(data: Constants.AuthKey.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"authKey")
                multipartFormData.appendBodyPart(data: "\(16)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"idUserChallenge")
                multipartFormData.appendBodyPart(data: "comment".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"comment")
                multipartFormData.appendBodyPart(data:"\(0.00)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"latitude")
                multipartFormData.appendBodyPart(data:"\(0.00)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"longitude")
                multipartFormData.appendBodyPart(data:"India".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"location")
        },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { request, response, JSON, error in
                        
                        
                    }
                case .Failure(let encodingError):
                    
                }
        }
        )*/
        
        
        
        /*Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "add"), method: .post, parameters: [
            "user_id": (experience.user?.id)!,
            "recipe_id": recipeId,
            "rating": experience.rating!,
            "comment": experience.comment!,
            "image_url": experience.imageURL!
        ], encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                completionHandler()
                break
            case .failure(let error):
                print(error)
                break
            }
        })*/
    }
}
