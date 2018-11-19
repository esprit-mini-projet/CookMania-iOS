//
//  Following.swift
//  CookMania
//
//  Created by Seif Abdennadher on 11/19/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

import UIKit
import ObjectMapper

class Following: Mappable {
    var follower: User?
    var following: User?
    private var dateString: String?
    var date: Date?
    
    let dateFroamtter = DateFormatter()
    
    required init?(map: Map) {
        dateFroamtter.locale = Locale(identifier: "en_US_POSIX")
        dateFroamtter.timeZone = TimeZone.autoupdatingCurrent
        dateFroamtter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
    
    func mapping(map: Map) {
        follower <- map["follower"]
        following <- map["following"]
        dateString <- map["date"]
        date = dateFroamtter.date(from: dateString!)
    }
}
