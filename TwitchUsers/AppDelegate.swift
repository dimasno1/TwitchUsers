//
//  AppDelegate.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.frame = UIScreen.main.bounds
        let rootController = TwitchTabBarController()
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()

        let twitchData = TwitchDataService()
        
//      twitchData.searchForUser(with: "dimasno1", delegate: SearchBarController())
        
        //        MARK: Recent User
        //        let jsonDecoder = JSONDecoder()
        //
        //        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        //        let path = url.appendingPathComponent("lastUserData.json")
        //        guard let data = try? Data(contentsOf: path) else { return false }
        //        do{
        //            let recentUser = try jsonDecoder.decode(UserInfo.self, from: data)
        //            let profileController = ProfileViewController(user: recentUser)
        //            rootController.present(profileController, animated: false, completion: nil)
        //        }catch{}
        
        return true
    }
    
}


