//
//  SessionDataHandler.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/18/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

protocol UserMetaHandlerDelegate: AnyObject {
    func didReceiveUsersMeta(sessionDataHandler: UserMetaHandler, meta: [Meta])
    func didntFindUser(sessionDataHandler: UserMetaHandler, error: String)
}

class UserMetaHandler: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    weak var delegate: UserMetaHandlerDelegate?
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let HTTPResponce = response as? HTTPURLResponse
        let statusCode = HTTPResponce?.statusCode
        
        if statusCode != 200{
            self.delegate?.didntFindUser(sessionDataHandler: self, error: "Error searching user: received \(statusCode ?? 0) status code")
            completionHandler(.cancel)
        }else{
            completionHandler(.allow)
        }
        session.finishTasksAndInvalidate()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        session.finishTasksAndInvalidate()
        guard let someUsers = try? JSONDecoder().decode(Users.self, from: data), someUsers.total > 0  else {
            self.delegate?.didntFindUser(sessionDataHandler: self, error: "No users found")
            return
        }
            self.meta = someUsers.meta
            self.delegate?.didReceiveUsersMeta(sessionDataHandler: self, meta: meta)
    }
    
    private var meta = [Meta]()
}
