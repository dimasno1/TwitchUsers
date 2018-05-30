//
//  SearchHistory.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/15/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class SearchHistory {
    
    private static var usersHistory = Set<Meta>()
    private static let notificationCenter = NotificationCenter.default
    
    static let shared = SearchHistory()
    
    private init() {
        
    }
    
    class func addUser(user: Meta){
        if !usersHistory.contains(user){
            usersHistory.insert(user)
            let addNotification = Notification(name: .searchHistoryAdd,
                                               object: self,
                                               userInfo:[
                                                "user": user,
                                                "numberOfUsers": usersHistory.count
                ])
            notificationCenter.post(addNotification)
        }
    }
    
    class func removeUser(user: Meta){
        if usersHistory.contains(user){
            usersHistory.remove(user)
            let removeNotification = Notification(name: .searchHistoryRemove, object: self, userInfo: ["user": user])
            notificationCenter.post(removeNotification)
        }
    }

}

extension Notification.Name {
    static let searchHistoryRemove = Notification.Name.init("remove")
    static let searchHistoryAdd = Notification.Name.init("add")
}
