//
//  TwitchUserSearcher.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/4/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class TwitchUserSearcher {
    
    var parameters = [Parameters.Keys.clientID: Parameters.Values.clientIDValue]
    
    private func makeURLFromParameters(_ parameters: [String: String], username: String) -> URL?{
        var components = URLComponents()
        components.scheme = Parameters.URLComponents.scheme
        components.host = Parameters.URLComponents.host
        components.path = Parameters.URLComponents.path + username
        
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters{
            let item = URLQueryItem(name: key, value: value )
            queryItems.append(item)
        }
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        return url
    }
    
    func searchForUser(with username: String, delegate: URLSessionDataDelegate){
        guard let url = makeURLFromParameters(parameters, username: username) else { return }
        print(url)
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        let task = session.dataTask(with: url)
        task.resume()
    }
   
}
