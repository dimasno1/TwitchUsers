//
//  SearchBarController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class SearchBarController: UISearchBar, UISearchBarDelegate{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.barStyle = .blackTranslucent
        self.showsCancelButton = true
        self.showsScopeBar = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //SearchBar delegate conforming:
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
        guard let windowOnScreenController = UIApplication.shared.keyWindow?.rootViewController else { return }
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: windowOnScreenController.view.frame.size.width - 10, height: windowOnScreenController.view.frame.size.height / 3)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let vcToPresent = UsersCollectionView(collectionViewLayout: layout)
        vcToPresent.collectionView?.backgroundColor = color
        
        windowOnScreenController.present(vcToPresent, animated: true, completion: nil)
        searchBar.resignFirstResponder()
    }
    
}

