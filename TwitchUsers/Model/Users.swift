//
//  Users.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/22/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

struct Users: Decodable {
    let total: Int
    let usersMeta: [NewUsersMeta]
    
    enum CodingKeys: String, CodingKey {
        case total = "_total"
        case usersMeta = "users"
    }
    
   
}
