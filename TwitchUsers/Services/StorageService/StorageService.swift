//
//  StorageService.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 6/5/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class StorageService: NSObject {
    
    init(userMeta: [Meta] = [], videosMeta: [VidMeta] = [], fileManager: FileManager = .default) {
        self.users = Users(meta: userMeta)
        self.videosMeta = videosMeta
        self.fileManager = fileManager
    }
    
    func saveToDisk() {
        let encoder = JSONEncoder.init()
        let userJSONFile = try? encoder.encode(users)
        writingData = userJSONFile
        print(needToWrite)
        if needToWrite {
            guard let url = Storage.users.getURL() else { return }
            
            do {
                try userJSONFile?.write(to: url)
            } catch {
                assertionFailure("failed to write to file at: \(url) with error: \(error.localizedDescription)")
            }
        } else {
            print("no need to write")
        }
    }
    
    func readFromDisk(forCheck: Bool) {
        let decoder = JSONDecoder.init()
        guard let url = Storage.users.getURL() else { return }
        guard  let data = try? Data(contentsOf: url) else { return }
        readedData = data
        if !forCheck {
            guard let users = try? decoder.decode(Users.self, from: data) else { return }
            for user in users.meta {
                SearchHistory.addUser(user: user)
            }
        }
    }
    
    private var needToWrite: Bool {
        readFromDisk(forCheck: true)
        return writingData != readedData
    }
    
    private var writingData: Data?
    private var readedData: Data?
    private var fileManager: FileManager
    private var users: Users
    private var videosMeta: [VidMeta]
}

extension StorageService {
    enum Storage {
        case users
        case videos
        
        func getURL() -> URL? {
            guard let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
            
            switch self {
            case .users:
                return URL(fileURLWithPath: docsPath).appendingPathComponent("users.json")
            case .videos:
                return URL(fileURLWithPath: docsPath).appendingPathComponent("videos.json")
            }
        }
    }
}
