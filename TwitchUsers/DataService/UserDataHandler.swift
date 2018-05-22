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
        
        print(jsonData)
        guard let users = try? JSONDecoder().decode(Users.self, from: jsonData) else {
            self.delegate?.didntFoundUser(sessionDataHandler: self, error: "No users found")
            return
        }
        let usersCount = users.usersMeta.count
        print(users.usersMeta[0].avatar, users.usersMeta[0].bio, users.usersMeta[0].id, users.usersMeta[0].logoURL, users.usersMeta[0].name, users.usersMeta[0].type)

                    if usersCount > 1{
        //                var foundUsers = [UserMeta]()
        //                for user in users{
        //                    guard let foundUser = user as? [String: AnyObject] else { return }
        //                    guard let someUser = self.getUserFrom(dictionary: foundUser, date: currentDate) else { return }
        //                    foundUsers.append(someUser)
        //                }
        //                self.delegate?.didFoundFewUsers(sessionDataHandler: self, users: foundUsers)
        //            }else if usersCount == 1{
        //                guard let foundUser = users[0] as? [String: AnyObject] else { return }
        //                guard let someUser = getUserFrom(dictionary: foundUser, date: currentDate) else { return }
        //                self.delegate?.didFoundUser(sessionDataHandler: self, user: someUser)
        //            }else{
        //                self.delegate?.didntFoundUser(sessionDataHandler: self, error: "No users found")
        //            }
        //        }catch{
        //
        //        }
    }
    
    private func encodeToJSONData(user: UserMeta){
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
