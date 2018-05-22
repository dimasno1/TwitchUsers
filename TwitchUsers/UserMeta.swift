//
//  UserInfoStruct.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/6/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit


class UserMeta: NSObject, Codable {
    
    var id: Int
    var searchingDate: Date
    var bio: String?
    var name: String
    var type: String
    var avatar: UIImage?
    var logoURL: String?
    
    //MARK: CustomStringConvertible:
    override var description: String {
        let hasAvatar = avatar == nil ? "Нет" : "Да"
        return "ID пользователя: \(id)\nИмя: \(name)\nТип: \(type)\nЕсть аватарка?: \(hasAvatar)\nБыл найден: \(searchingDate) "
    }
    
    //MARK: Hashable & Equatable
    static func == (lhs: UserMeta, rhs: UserMeta) -> Bool {
        return
                lhs.id == rhs.id &&
                lhs.name == rhs.name &&
                lhs.type == rhs.type
    }
    
    override var hashValue: Int{
        return id.hashValue ^ name.hashValue ^ type.hashValue & 192378
    }

    //MARK: NSObject Hashable & Equatable:
    override func isEqual(_ object: Any?) -> Bool {
        let lhs = self
        if let rhs = object as? UserMeta {
            return lhs == rhs
        }
        return false
    }
    
    override var hash: Int{
        return self.hashValue
    }
    
    //MARK: Initialization:
    init(id: Int, name: String, type: String, avatar: UIImage?, searchingDate: Date, bio: String?) {
        self.id = id
        self.name = name
        self.type = type
        self.avatar = avatar
        self.searchingDate = searchingDate
        self.bio = bio
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        bio = try container.decode(String.self, forKey: .bio)
        searchingDate = try container.decode(Date.self, forKey: .searchingDate)
        
        let imageData = try container.decode(Data.self, forKey: .logoURL)
        avatar = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage ?? nil
    }
    
    //MARK: Codable:
    enum CodingKeys: String, CodingKey{
        case id = "_id"
        case bio = "bio"
        case name = "name"
        case type = "type"
        case logoURL = "logo"
        case searchingDate = "searching_date"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(searchingDate, forKey: .searchingDate)
        try container.encode(bio, forKey: .bio)
        
        if let avatar = avatar{
            let image = NSKeyedArchiver.archivedData(withRootObject: avatar)
            try container.encode(image, forKey: .logoURL)
        }
    }
}
