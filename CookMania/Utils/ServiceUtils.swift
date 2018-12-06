//
//  ServiceUtils.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/17/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit

final class ServiceUtils: NSObject {
    
    static func buildURL(route: String, postfix: String) -> String {
        return AppDelegate.SERVER_DOMAIN+route+"/"+postfix
    }
}
