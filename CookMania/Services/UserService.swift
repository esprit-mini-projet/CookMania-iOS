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
    
    func getUser(id: String, completionHandler: @escaping (_ user: User) -> ()) {
        print("BEGIN GET")
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: id)).responseString(completionHandler: { (response: DataResponse<String>) in
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
    
    func logUserIn(email: String, password: String, completionHandler: @escaping (_ user: User?) -> ()){
        let uuid: String =  (UIDevice.current.identifierForVendor?.uuidString)!
        let token: String = AppDelegate.getDeviceToken()
        
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "signin"), method: .post, parameters: ["email": email, "password": password, "type": "ios", "uuid": uuid, "token": token], encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                let user: User? = Mapper<User>().map(JSONString: response.result.value!)
                completionHandler(user)
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func checkUserSocial(user: User, completionHandler: @escaping (_ user: User) -> ()) {
        var JSONObject = user.toJSON()
        JSONObject["uuid"] = UIDevice.current.identifierForVendor?.uuidString
        JSONObject["token"] = AppDelegate.getDeviceToken()
        JSONObject["type"] = "ios"
        do{
            let JSONString = try JSONSerialization.data(withJSONObject: JSONObject, options: [])
            var request = URLRequest(url: URL(string: ServiceUtils.buildURL(route: ROUTE, postfix: "social/check"))! )
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = JSONString
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
        }catch{
            print(error.localizedDescription)
        }
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
    
    func getUserFollowers(user: User, completionHandler: @escaping (_ followers: [Following]) -> ()) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "followers/"+String(user.id!))).responseString(completionHandler: { (response: DataResponse<String>) in
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
    
    func getUserFollowing(user: User, completionHandler: @escaping (_ following: [Following]) -> ()) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "following/"+String(user.id!))).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                let following: [Following] = Mapper<Following>().mapArray(JSONString: response.result.value!)!
                completionHandler(following)
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func follow(follower: User, followed: User, completionHandler: @escaping () -> ()) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "follow/"+String(follower.id!)+"/"+String(followed.id!)), method: .post).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                completionHandler()
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func unfollow(follower: User, followed: User, completionHandler: @escaping () -> ()) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "unfollow/"+String(follower.id!)+"/"+String(followed.id!)), method: .delete)
            .responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                completionHandler()
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func logout(completionHandler: @escaping () -> ()) {
        Alamofire.request(ServiceUtils.buildURL(route: ROUTE, postfix: "logout"), method: .post, parameters: ["uuid": UIDevice.current.identifierForVendor?.uuidString], encoding: JSONEncoding.default, headers: nil).responseString(completionHandler: { (response: DataResponse<String>) in
            switch response.result {
            case .success:
                completionHandler()
                break
            case .failure(let error):
                print(error)
                break
            }
        })
    }
    
    func updateUser(user: User, image: UIImage?, completionHandler: @escaping () -> ()) {
        print("BEGIN UPDATE")
        let url = try! URLRequest(url: URL(string: ServiceUtils.buildURL(route: ROUTE, postfix: "update"))!, method: .post, headers: nil)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if image != nil {
                multipartFormData.append(image!.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "send.png", mimeType: "image/jpg")
            }
            multipartFormData.append((user.id)!.data(using: .utf8)!, withName: "id", mimeType: "text/plain")
            multipartFormData.append((user.username)!.data(using: .utf8)!, withName: "username", mimeType: "text/plain")
            multipartFormData.append((user.email)!.data(using: .utf8)!, withName: "email", mimeType: "text/plain")
            multipartFormData.append((user.password)!.data(using: .utf8)!, withName: "password", mimeType: "text/plain")
        }, with: url, encodingCompletion: { (result) in
            switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        completionHandler()
                    }
                case .failure(let encodingError):
                    print("",encodingError.localizedDescription)
            }
        })
    }
    
    func addUser(user: User, image: UIImage?, completionHandler: @escaping () -> ()) {
        let url = try! URLRequest(url: URL(string: ServiceUtils.buildURL(route: ROUTE, postfix: "insert"))!, method: .post, headers: nil)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if image != nil {
                multipartFormData.append(image!.jpegData(compressionQuality: 0.5)!, withName: "image", fileName: "send.png", mimeType: "image/jpg")
            }
            multipartFormData.append((user.username)!.data(using: .utf8)!, withName: "username", mimeType: "text/plain")
            multipartFormData.append((user.email)!.data(using: .utf8)!, withName: "email", mimeType: "text/plain")
            multipartFormData.append((user.password)!.data(using: .utf8)!, withName: "password", mimeType: "text/plain")
        }, with: url, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    completionHandler()
                }
            case .failure(let encodingError):
                print("",encodingError.localizedDescription)
            }
        })
    }
}
