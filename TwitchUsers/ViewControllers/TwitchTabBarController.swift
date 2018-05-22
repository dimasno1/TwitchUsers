//
//  TwitchTabBarController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/13/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class TwitchTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBarItemForSearchView = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        tabBarItemForSearchView.badgeColor = .red
        let tabBarItemForResultsView = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        self.setViewControllers([searchViewController, resultsViewController], animated: true)
        self.tabBar.barStyle = .black
        
        searchViewController.tabBarItem = tabBarItemForSearchView
        resultsViewController.tabBarItem = tabBarItemForResultsView
    }
    
    let searchViewController = SearchViewController()
    let resultsViewController: HistoryOfSearchCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        let controller = HistoryOfSearchCollectionViewController(collectionViewLayout: layout)
        return controller
    }()
 
}
