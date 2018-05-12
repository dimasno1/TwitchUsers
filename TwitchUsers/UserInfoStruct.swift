//
//  UserInfoStruct.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/6/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit


struct UserInfo: Codable{
    
    var id: Int
    var name: String
    var type: String
    var avatar: UIImage?
    
    init(id: Int, name: String, type: String, avatar: UIImage?) {
        self.id = id
        self.name = name
        self.type = type
        self.avatar = avatar
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case name = "twitch_username"
        case type = "twitch_usertype"
        case avatar = "profile_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        
        let imageData = try container.decode(Data.self, forKey: .avatar)
        avatar = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage ?? nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        
        if let avatar = avatar{
            let image = NSKeyedArchiver.archivedData(withRootObject: avatar)
            try container.encode(image, forKey: .avatar)
        }
    }
}

var users = [UserInfo]()

