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
}
