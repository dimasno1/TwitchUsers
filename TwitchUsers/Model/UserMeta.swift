//
//  UserMeta.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/22/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class UserMeta: NSObject, Codable {

    //MARK: CustomStringConvertible:
    override var description: String {
        let hasAvatar = avatar == nil ? "Нет" : "Да"
        return "ID пользователя: \(id)\nИмя: \(name)\nТип: \(type)\nЕсть аватарка?: \(hasAvatar)"
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
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type = "type"
        case logoURL = "logo"
        case bio = "bio"
        case name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        bio = try? container.decode(String.self, forKey: .bio)
        logoURL = try container.decode(String.self, forKey: .logoURL)
        
        guard let url = URL(string: logoURL) else { return }
        let logoData = try Data(contentsOf: url)
        self.avatar = UIImage(data: logoData)
    }
    
    var name: String
    var type: String
    var id: String
    var logoURL: String
    var bio: String?
    var avatar: UIImage?
}
