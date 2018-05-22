//
//  SearchHistory.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/15/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class SearchHistory{
    
    var usersHistory = Set<UserMeta>()
    
    let notificationCenter = NotificationCenter.default
    
    func addUser(user: UserMeta){
        if !usersHistory.contains(user){
            usersHistory.insert(user)
            let addNotification = Notification(name: Notification.Name(rawValue: "AddedUser"), object: self, userInfo:
                ["user": user,
                 "numberOfUsers": usersHistory.count
                ])
            notificationCenter.post(addNotification)
        }
    }
    
    func removeUser(user: UserMeta){
        if usersHistory.contains(user){
            usersHistory.remove(user)
            let removeNotification = Notification(name: Notification.Name(rawValue: "RemovedUser"), object: self, userInfo: ["user": user])
            notificationCenter.post(removeNotification)
        }
    }
    
}
