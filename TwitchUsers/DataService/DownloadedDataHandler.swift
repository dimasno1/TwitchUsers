//
//  DownloadedDataHandler.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class DownloadedDataHandler: UserMetaHandlerDelegate, VideoDataHandlerDelegate{
    
    var caller: SearchViewController
    lazy var userDataHandler = UserMetaHandler()
    lazy var videoDataHandler = VideoMetaHandler()
    
    init(caller: SearchViewController) {
        self.caller = caller
        userDataHandler.delegate = self
        videoDataHandler.delegate = self
    }
    
    //MARK: UsersDelegate conforming:
    func didReceivedUserMeta(sessionDataHandler: UserMetaHandler, user: Meta) {
        DispatchQueue.main.async { [weak caller] in
            caller?.stopActivityIndicatorAnimation()
            caller?.updateHistory(with: user)
            let profileController = ProfileViewController(user: user)
            caller?.present(profileController, animated: true, completion: nil)
        }
    }
    
    func didReceiveUsersMeta(sessionDataHandler: UserMetaHandler, meta: [Meta]) {
        
        DispatchQueue.main.async { [weak caller] in
            caller?.stopActivityIndicatorAnimation()
            let usersViewController = UsersScrollViewController()
            for user in meta{
                caller?.updateHistory(with: user)
                let profileViewController = ProfileViewController(user: user)
                usersViewController.addAsChildViewContoller(profileViewController: profileViewController)
            }
            caller?.present(usersViewController, animated: true, completion: nil)
        }
    }
    
    func didntFoundUser(sessionDataHandler: UserMetaHandler, error: String) {
        print(error)
        DispatchQueue.main.async {
            self.caller.stopActivityIndicatorAnimation()
            self.caller.setLabelToNotFound()
        }
    }
    
    //MARK: VideosDelegate conforming:
    func didReceivedVideosMeta(videoDataHandler: VideoMetaHandler, meta: Any) {
        print("didReceivedVideosMeta")
    }
    
    func didntReceivedVideosMeta(videoDataHandler: VideoMetaHandler, error: String) {
        print("didntReceivedVideosMeta")
    }
    
}
