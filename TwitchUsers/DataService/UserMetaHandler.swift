//
//  SessionDataHandler.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/18/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

protocol UserMetaHandlerDelegate: AnyObject{
    
    func didReceivedUserMeta(sessionDataHandler: UserMetaHandler, user: Meta)
    func didReceiveUsersMeta(sessionDataHandler: UserMetaHandler, meta: [Meta])
    func didntFoundUser(sessionDataHandler: UserMetaHandler, error: String)
}

class UserMetaHandler: NSObject, URLSessionDataDelegate {
    
    weak var delegate: UserMetaHandlerDelegate?
    
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
        
        switch users.meta.count {
        case 1:
            let user = users.meta[0]
            self.delegate?.didReceivedUserMeta(sessionDataHandler: self, user: user)
        case 1 ... Int.max:
             self.delegate?.didReceiveUsersMeta(sessionDataHandler: self, meta: users.meta)
        default:
            self.delegate?.didntFoundUser(sessionDataHandler: self, error: "No users found")
        }
    }
    
    private func encodeToJSONData(users: Users){
        do{
            let fileManager = FileManager.default
            let encoder = JSONEncoder.init()
            let json = try encoder.encode(users)
            if let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
                var path = url.path
                path.append("/users.json")
                print(path)
                fileManager.createFile(atPath: path, contents: json, attributes: nil)
            }
        }catch{
            print("Oops ... unable to create file")
        }
    }
}
