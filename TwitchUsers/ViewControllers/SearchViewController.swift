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

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = searchBar
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mainLabel.text != commonText{
            mainLabel.text = commonText
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = mainTwitchColor
        self.view.addSubviews(searchBar, mainLabel, activityIndicator)
        mainLabel.font = twitchFont
        mainLabel.textColor = .gray
        mainLabel.text = commonText
        mainLabel.sizeToFit()
        makeConstraits()
    }
    
    private func makeConstraits() {
        searchBar.snp.makeConstraints { make in
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
    
    func startActivityIndicatorAnimation() {
        activityIndicator.startAnimating()
    }
   
    func stopActivityIndicatorAnimation() {
        activityIndicator.stopAnimating()
    }
    func setLabelToNotFound() {
        mainLabel.text = noSuchUserText
    }
    
    func updateHistory(with userMeta: Meta) {
        searchHistory.addUser(user: userMeta)
    }
    
    private let noSuchUserText = "No such user"
    private let commonText = "twitch users"
    private let mainLabel = UILabel()
    private lazy var searchHistory = SearchHistory()
    lazy var downloadedDataHandler = DownloadedDataHandler(caller: self)
    private let searchBar = MainSearchBar()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
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
