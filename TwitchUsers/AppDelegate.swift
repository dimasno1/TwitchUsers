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
        
        return true
    }
    
    //FIXME: if needed
//    private func encodeToJSONDataUsers(with meta: [Meta]){
//        do{
//            let fileManager = FileManager.default
//            let encoder = JSONEncoder.init()
//            let json = try encoder.encode(meta)
//            print(json)
//            if let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
//                var path = url.path
//                path.append("/users.json")
//                urlFile = URL(fileURLWithPath: path)
//                fileManager.createFile(atPath: path, contents: json, attributes: nil)
//            }
//        }catch{
//            print("Oops ... unable to create file")
//        }
//    }
}


