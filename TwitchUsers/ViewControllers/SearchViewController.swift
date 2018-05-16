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

class SearchViewController: UIViewController, SearchBarControllerDelegate{
    
    let searchHistory = SearchHistory()
    let searchbar = SearchBarController()
    let notificationCenter = NotificationCenter.default
    let mainLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    //MARK: ViewController lifecycle:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.barDelegate = self
        searchbar.delegate = searchbar
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mainLabel.text != "twitch users"{
           mainLabel.text = "twitch users"
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
        mainLabel.text = "twitch users"
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
    
    //MARK: Delegate conforming:
    
    func didFoundUser(searchBarController: SearchBarController, user: UserInfo) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.searchHistory.addUser(user: user)
            let viewControllerToPresent = ProfileViewController(user: user)
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func didntFoundUser(searchBarController: SearchBarController, error: String) {
        print(error)
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.mainLabel.text = "No such user"
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }

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
