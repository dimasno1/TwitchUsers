//
//  ViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit
import SnapKit

let mainTwitchColor = UIColor(withFromZeroToRed: 75, green: 56, blue: 122)
let twitchFont = UIFont(name: "DimitriSwank", size: 35)

class SearchViewController: UIViewController, UserDataHandlerDelegate, VideoDataHandlerDelegate{
    
    //MARK: ViewController lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataHandler.delegate = self
        videoDataHandler.delegate = self
        searchbar.delegate = searchbar
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mainLabel.text != commonText{
            mainLabel.text = commonText
        }
    }
 
    private func setupView(){
        self.view.backgroundColor = mainTwitchColor
        self.view.addSubviews(searchbar, mainLabel, activityIndicator)
        mainLabel.font = twitchFont
        mainLabel.text = commonText
        mainLabel.sizeToFit()
        makeConstraits()
    }
    
    private func makeConstraits() {
        searchbar.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
 
        mainLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }

        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(mainLabel.snp.bottom).offset(30)
        }
    }
    
    //MARK: UsersDelegate conforming:
    func didFoundUser(sessionDataHandler: UserDataHandler, user: UserMeta) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.searchHistory.addUser(user: user)
            let profileController = ProfileViewController(user: user)
            self.present(profileController, animated: true, completion: nil)
        }
    }
    
    func didFoundFewUsers(sessionDataHandler: UserDataHandler, users: [UserMeta]) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let usersViewController = UsersScrollViewController()
            for user in users{
                self.searchHistory.addUser(user: user)
                let profileViewController = ProfileViewController(user: user)
                usersViewController.addAsChildViewContoller(profileViewController: profileViewController)
            }
            self.present(usersViewController, animated: true, completion: nil)
        }
    }
    
    func didntFoundUser(sessionDataHandler: UserDataHandler, error: String) {
        print(error)
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.mainLabel.text = self.noSuchUserText
        }
    }
    
    //MARK: VideosDelegate conforming:
    func didReceivedVideosMeta(videoDataHandler: VideoDataHandler, meta: Any) {
        print("yo")
    }
    
    func didntReceivedVideosMeta(videoDataHandler: VideoDataHandler, error: String) {
        print("yo")
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    private let noSuchUserText = "No such user"
    private let commonText = "twitch users"
    private let mainLabel = UILabel()
    private let notificationCenter = NotificationCenter.default
    lazy var userDataHandler = UserDataHandler()
    lazy var videoDataHandler = VideoDataHandler()
    private lazy var searchHistory = SearchHistory()
   
    let searchbar = SearchBarController()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
}


//UIColor extensions:
extension UIColor{
    convenience init(withFromZeroToRed: CGFloat, green: CGFloat, blue: CGFloat) {
        let newRed = withFromZeroToRed/255
        let newGreen = green/255
        let newBlue = blue/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1)
    }
}
