//
//  SearchBarController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class SearchBarController: UISearchBar, UISearchBarDelegate {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.barStyle = .blackTranslucent
        self.keyboardAppearance = .dark
        self.showsCancelButton = true
        self.showsScopeBar = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: SearchBar delegate conforming:
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
        guard let windowOnScreenController = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers[0] as? SearchViewController else { return }
        DispatchQueue.main.async {
            windowOnScreenController.activityIndicator.startAnimating()
        }
        let twitchSearcher = TwitchDataService()
        let name = searchBar.text?.lowercased()
//        twitchSearcher.searchForTopVideos(limit: 2, game: "Overwatch", delegate: windowOnScreenController.videoDataHandler)
        twitchSearcher.searchForUser(with: name ?? "", delegate: windowOnScreenController.userDataHandler)
        searchBar.resignFirstResponder()
    }
}
