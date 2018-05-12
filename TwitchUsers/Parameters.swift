//
//  Parameters.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/6/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import Foundation

struct Parameters{
    
    struct URLComponents {
        static let scheme = "https"
        static let host = "api.twitch.tv"
        static let path = "/kraken/users/"
    }
    
    struct Keys{
        static let clientID = "client_id"
    }
    struct Values{
        static let clientIDValue = "2rlbcgxs8jy2nradngk1pcu1bmwv89"
    }
}
