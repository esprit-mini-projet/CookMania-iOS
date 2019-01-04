//
//  NotificationType.swift
//  CookMania
//
//  Created by Seif Abdennadher on 12/14/18.
//  Copyright © 2018 MiniProjet. All rights reserved.
//

struct NotificationType {
    static let followingAddedRecipe = 1
    static let follower = 2
}

class NotificationWrapper {
    var notificationId: String
    var notificationType: Int
    
    init(notificationId: String, notificationType: Int) {
        self.notificationId = notificationId
        self.notificationType = notificationType
    }
}
