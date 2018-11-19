//
//  UserService.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/17/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class UserService: NSObject {
    private let ROUTE = "/users"
    
    private static var instance: UserService?
    
    private override init() {}
    
    public static func getInstance() -> UserService{
        if(instance == nil){
            instance = UserService()
        }
        return instance!
    }
    
    func logUserIn(email: String, password: String, completionHandler: @escaping (_ user: User) -> ()){
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "signin"), method: .post, parameters: ["email": email, "password": password],encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                let user: User = Mapper<User>().map(JSONString: response.result.value!)!
                completionHandler(user)
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func checkUserSocial(user: User, completionHandler: @escaping (_ user: User) -> ()) {
        let JSONString = user.toJSONString(prettyPrint: true)
        var request = URLRequest(url: URL(string: ServiceUtils.buildURL(route: ROUTE, postfix: "social/check"))! )
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = JSONString!.data(using: .utf8, allowLossyConversion: false)!
        Alamofire.request(request).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                let user: User = Mapper<User>().map(JSONString: response.result.value!)!
                completionHandler(user)
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func getUsersRecipes(user: User, completionHandler: @escaping (_ recipes: [Recipe]) -> ()){
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "recipes/"+String(user.id!))).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                let recipes: [Recipe] = Mapper<Recipe>().mapArray(JSONString: response.result.value!)!
                completionHandler(recipes)
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func getUserFollowers(usre: User, completionHandler: @escaping (_ followers: [Following]) -> ()) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "followers/"+String(usre.id!))).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                let followers: [Following] = Mapper<Following>().mapArray(JSONString: response.result.value!)!
                completionHandler(followers)
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
}
