//
//  ViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

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
        notificationCenter.addObserver(self, selector: #selector(makeLayout), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationCenter.removeObserver(self, name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    private func setupView(){
        self.view.backgroundColor = mainTwitchColor
        self.view.addSubview(searchbar)
        self.view.addSubview(mainLabel)
        self.view.addSubview(activityIndicator)
        mainLabel.font = twitchFont
        mainLabel.text = commonText
        mainLabel.sizeToFit()
    }
    
    @objc private func makeLayout(notification: Notification?){
        let someSize = self.searchbar.sizeThatFits(self.view.bounds.size)
        let frameOfSafeArea = self.view.safeAreaLayoutGuide.layoutFrame
        searchbar.frame.origin = CGPoint(x: 0, y: frameOfSafeArea.minY)
        self.searchbar.frame.size = someSize
        mainLabel.center = self.view.center
        let transform = CGAffineTransform(translationX: 0, y: 50)
        activityIndicator.center = mainLabel.center.applying(transform)
    }
    
    //MARK: UsersDelegate conforming:
    func didFoundUser(sessionDataHandler: UserDataHandler, user: UserInfo) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.searchHistory.addUser(user: user)
            let profileController = ProfileViewController(user: user)
            self.present(profileController, animated: true, completion: nil)
        }
    }
    
    func didFoundFewUsers(sessionDataHandler: UserDataHandler, users: [UserInfo]) {
        
            DispatchQueue.main.async {
                self.fewFoundUsersController.prepareForNewUsers()
                self.activityIndicator.stopAnimating()
                for user in users{
                    self.searchHistory.addUser(user: user)
                    let profileViewController = ProfileViewController(user: user)
                    self.fewFoundUsersController.addAsChildViewContoller(profileViewController: profileViewController)
                }
                self.present(self.fewFoundUsersController, animated: true, completion: nil)
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
    private let searchHistory = SearchHistory()
    private let mainLabel = UILabel()
    private let notificationCenter = NotificationCenter.default
    lazy var fewFoundUsersController = FewFoundUsersViewController()
    let userDataHandler = UserDataHandler()
    let videoDataHandler = VideoDataHandler()
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
