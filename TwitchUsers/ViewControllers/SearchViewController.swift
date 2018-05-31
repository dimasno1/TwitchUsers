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
    
    func startActivityIndicatorAnimation() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicatorAnimation() {
        activityIndicator.stopAnimating()
    }
    
    func updateHistory(with userMeta: Meta) {
        SearchHistory.addUser(user: userMeta)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mainLabel.text != commonText{
            mainLabel.text = commonText
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupView() {
        self.view.backgroundColor = mainTwitchColor
        self.view.addSubviews(searchBar, mainLabel, activityIndicator)
        mainLabel.font = twitchFont
        mainLabel.textColor = .gray
        mainLabel.text = commonText
        mainLabel.sizeToFit()
        makeConstraits()
        searchBar.placeholder = "write username here..."
        twitchDataService.delegate = self
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
    
    private let commonText = "twitch users"
    private let mainLabel = UILabel()
    private let searchBar = MainSearchBar()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    private var profileController = ProfileViewController()
    private var usersViewController = UsersPageViewController()
    private let twitchDataService = TwitchDataService()
    private var alertController = TwitchAlertController()
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.startActivityIndicatorAnimation()
    
        let names = searchBar.text?.lowercased().replacingOccurrences(of: " ", with: "")
        twitchDataService.searchForUser(with: names ?? "")
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: TwitchDataServiceDelegate {
    
    func didReceiveUsersMeta(sessionDataHandler: UserMetaHandler, meta: [Meta]) {
        self.stopActivityIndicatorAnimation()
        usersViewController = UsersPageViewController()
        for user in meta{
            self.updateHistory(with: user)
            self.profileController = ProfileViewController(user: user)
            usersViewController.addAsChildViewContoller(profileViewController: self.profileController)
        }
        self.present(usersViewController, animated: true, completion: nil)
    }
    
    func didntFindUser(sessionDataHandler: UserMetaHandler, error: String) {
        self.stopActivityIndicatorAnimation()
        let image = UIImage(named: "fish.jpg")
        alertController = TwitchAlertController(title: "No such user", message: "Try again", backgroundImage: image)
        
        let actionthree = TwitchAlertAction(alertTitle: "Retry",
                                            style: .common,
                                            handler:
                                                    {
                                                        self.searchBar.becomeFirstResponder()
                                                        self.dismiss(animated: true, completion: nil)
                                                        self.searchBar.delegate?.searchBarSearchButtonClicked?(self.searchBar)
                                                    }
        )
        
        let actionfour = TwitchAlertAction(alertTitle: "Close", style: .destructive, handler: { self.dismiss(animated: true, completion: nil)})
        
        alertController.addActions(actionthree, actionfour)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: VideosDelegate conforming:
    func didReceivedVideosMeta(videoDataHandler: VideoMetaHandler, meta: Any) {
        
    }
    
    func didntReceivedVideosMeta(videoDataHandler: VideoMetaHandler, error: String) {
        
    }
}
