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
}
