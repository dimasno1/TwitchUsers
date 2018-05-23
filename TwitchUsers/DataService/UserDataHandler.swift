//
//  SessionDataHandler.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/18/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

protocol UserDataHandlerDelegate: AnyObject{
    
    func didFoundUser(sessionDataHandler: UserDataHandler, user: UserMeta)
    func didFoundFewUsers(sessionDataHandler: UserDataHandler, users: [UserMeta])
    func didntFoundUser(sessionDataHandler: UserDataHandler, error: String)
}

class UserDataHandler: NSObject, URLSessionDataDelegate {
    
    weak var delegate: UserDataHandlerDelegate?
    
    //MARK: URLSession delegate conforming:
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let HTTPResponce = response as? HTTPURLResponse
        let statusCode = HTTPResponce?.statusCode
        
        if statusCode != 200{
            self.delegate?.didntFoundUser(sessionDataHandler: self, error: "Error searching user: received \(statusCode ?? 0) status code")
            completionHandler(.cancel)
        }else{
            completionHandler(.allow)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        let jsonData = data
        guard let users = try? JSONDecoder().decode(Users.self, from: jsonData) else {
            self.delegate?.didntFoundUser(sessionDataHandler: self, error: "No users found")
            return
        }
        
        switch users.usersMeta.count {
        case 1:
            let user = users.usersMeta[0]
            self.delegate?.didFoundUser(sessionDataHandler: self, user: user)
        case 1 ... Int.max:
             self.delegate?.didFoundFewUsers(sessionDataHandler: self, users: users.usersMeta)
        default:
            self.delegate?.didntFoundUser(sessionDataHandler: self, error: "No users found")
        }
    }
    
    private func encodeToJSONData(user: UserMeta){
        do{
            let fileManager = FileManager.default
            let encoder = JSONEncoder.init()
            let json = try encoder.encode(user)
            if let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
                var path = url.path
                path.append("/lastUserData.json")
                print(path)
                fileManager.createFile(atPath: path, contents: json, attributes: nil)
            }
        }catch{
            print("Oops ... unable to create file")
        }
    }
}
