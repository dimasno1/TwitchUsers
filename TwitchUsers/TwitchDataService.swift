//
//  TwitchUserSearcher.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/4/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class TwitchDataService {
    
    private func makeURLFromParameters(_ parameters: [String: String], appendingPath: String) -> URL? {
        
        var components = URLComponents()
        components.scheme = URLComponent.scheme
        components.host = URLComponent.host
        components.path = URLComponent.path + appendingPath
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        
        return url
    }
    
    func searchForTopVideos(limit: Int, game: String, delegate: URLSessionDataDelegate) {
        
        let videoParameters = [Key.limit: String(limit), Key.game: game]
        guard let videosUrl = makeURLFromParameters(videoParameters, appendingPath: URLComponent.videosPath) else { return }
        
        let videoSession = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        var videoRequest = URLRequest(url: videosUrl)
        
        videoRequest.addValue(Value.acceptHeader, forHTTPHeaderField: Key.acceptHeader)
        videoRequest.addValue(Value.clientID, forHTTPHeaderField: Key.cliendIDHeader)
        
        let task = videoSession.dataTask(with: videoRequest)
        print(videosUrl)
        task.resume()
    }
    
    func searchForUser(with username: String, delegate: URLSessionDataDelegate) {
        
        let userParameters = [Key.login: username]
        guard let usersUrl = makeURLFromParameters(userParameters, appendingPath: URLComponent.usersPath) else { return }

        let usersSession = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        var usersRequest = URLRequest(url: usersUrl)
        
        usersRequest.addValue(Value.acceptHeader, forHTTPHeaderField: Key.acceptHeader)
        usersRequest.addValue(Value.clientID, forHTTPHeaderField: Key.cliendIDHeader)
        let task = usersSession.dataTask(with: usersRequest)
        task.resume()
    }
    
}

extension TwitchDataService {

    struct URLComponent {
        static let scheme = "https"
        static let host = "api.twitch.tv"
        static let path = "/kraken/"
        static let usersPath = "users"
        static let videosPath = "videos/top"
    }
    
    struct Key {
        static let acceptHeader = "Accept"
        static let cliendIDHeader = "Client-ID"
        static let clientID = "client_id"
        static let login = "login"
        static let game = "game"
        static let limit = "limit"
    }
    
    struct Value {
        static let acceptHeader = "application/vnd.twitchtv.v5+json"
        static let clientID = "2rlbcgxs8jy2nradngk1pcu1bmwv89"
    }
}
