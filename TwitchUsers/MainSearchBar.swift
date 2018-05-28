//
//  SearchBarController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class MainSearchBar: UISearchBar {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        barStyle = .blackTranslucent
        tintColor = secondTwitchColor
        keyboardAppearance = .dark
        showsCancelButton = true
        showsScopeBar = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainSearchBar: UISearchBarDelegate {
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
            windowOnScreenController.startActivityIndicatorAnimation()
        }
        let twitchSearcher = TwitchDataService()
        let names = searchBar.text?.lowercased().replacingOccurrences(of: " ", with: "")
        twitchSearcher.searchForUser(with: names ?? "", delegate: windowOnScreenController.downloadedDataHandler.userDataHandler)
        searchBar.resignFirstResponder()
    }
}
