//
//  ViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

let mainTwitchColor = UIColor(withFromZeroToRed: 75, green: 56, blue: 122)
let font = UIFont(name: "DimitriSwank", size: 35)

class SearchViewController: UIViewController, UISearchBarDelegate, SearchBarControllerDelegate{
    
    let searchbar = SearchBarController()
    let notificationCenter = NotificationCenter.default
    let labelTest = UILabel()
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
        
        if labelTest.text != "twitch users"{
           labelTest.text = "twitch users"
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
        self.view.addSubview(labelTest)
        self.view.addSubview(activityIndicator)
        labelTest.font = font
        labelTest.text = "twitch users"
        labelTest.sizeToFit()
    }
    
    @objc func makeLayout(notification: Notification){
        let someSize = self.searchbar.sizeThatFits(self.view.bounds.size)
        let frameOfSafeArea = self.view.safeAreaLayoutGuide.layoutFrame
        searchbar.frame.origin = CGPoint(x: 0, y: frameOfSafeArea.minY)
        self.searchbar.frame.size = someSize
        labelTest.center = self.view.center
        let transform = CGAffineTransform(translationX: 0, y: 50)
        activityIndicator.center = labelTest.center.applying(transform)
    }
    
    //MARK: Delegate conforming:
    
    func didFoundUser(searchBarController: SearchBarController, user: UserInfo) {
     
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            let viewControllerToPresent = ProfileViewController(user: user)
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func didntFoundUser(searchBarController: SearchBarController, error: String) {
        print(error)
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.labelTest.text = "No such user"
        }
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
