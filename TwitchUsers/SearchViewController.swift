//
//  ViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

let color = UIColor(withFromZeroToRed: 75, green: 56, blue: 122)

class SearchViewController: UIViewController, UISearchBarDelegate{
    
    let searchbar = SearchBarController()
    let notificationCenter = NotificationCenter.default
    let font = UIFont(name: "DimitriSwank", size: 35)
    let labelTest = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.delegate = searchbar
        self.view.addSubview(searchbar)
        self.view.addSubview(labelTest)
        self.setup()
        notificationCenter.addObserver(self, selector: #selector(makeLayout), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func setup(){
        self.view.backgroundColor = color
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
