//
//  SessionDataHandler.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/18/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

protocol UserDataHandlerDelegate: AnyObject{
    
    func didFoundUser(sessionDataHandler: UserDataHandler, user: UserInfo)
    func didFoundFewUsers(sessionDataHandler: UserDataHandler, users: [UserInfo])
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
        let currentDate = Date()
        var jsonDictionary = [String: AnyObject]()
        do{
            jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! [String: AnyObject]
            guard let usersCount = jsonDictionary["_total"] as? Int else { return }
            guard let users = jsonDictionary["users"] as? NSArray else { return }
            
            if usersCount > 1{
                var foundUsers = [UserInfo]()
                for user in users{
                    guard let foundUser = user as? [String: AnyObject] else { return }
                    guard let someUser = self.getUserFrom(dictionary: foundUser, date: currentDate) else { return }
                    foundUsers.append(someUser)
                }
                self.delegate?.didFoundFewUsers(sessionDataHandler: self, users: foundUsers)
            }else{
                guard let foundUser = users[0] as? [String: AnyObject] else { return }
                guard let someUser = getUserFrom(dictionary: foundUser, date: currentDate) else { return }
                self.delegate?.didFoundUser(sessionDataHandler: self, user: someUser)
            }
        }catch{
            
        }
    }
    
    private func getUserFrom(dictionary: [String: AnyObject], date: Date) -> UserInfo? {
        guard let id = dictionary["_id"] as? String else { return nil}
        guard let newID = Int(id) else { return nil}
        guard let name = dictionary["name"] as? String else { return nil}
        guard let type = dictionary["type"] as? String else { return nil}
        guard let logo = dictionary["logo"] as? String else { return nil}
        guard let logoURL = URL(string: logo) else { return nil}
        var bio: String?
        if let userBio = dictionary["bio"] as? String{
            bio = userBio
        }
        
        guard let imageData = try? Data(contentsOf: logoURL) else { return nil }
        let avatar = UIImage(data: imageData)
        let currentUser = UserInfo(id: newID, name: name, type: type, avatar: avatar ?? nil, searchingDate: date, bio: bio)
        return currentUser
    }
    
    private func encodeToJSONData(user: UserInfo){
        do{
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
    
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder.init()
}
