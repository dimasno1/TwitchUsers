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
        let tabBarItemForResultsView = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        searchViewController.tabBarItem = tabBarItemForSearchView
        historyListController.tabBarItem = tabBarItemForResultsView
        setup()
    }
    
    private func setup() {
        tabBar.barStyle = .black
        tabBar.tintColor = secondTwitchColor
        setViewControllers([searchViewController, historyListController], animated: true)
    }
    
    private let searchViewController = SearchViewController()
    private lazy var historyListController: HistoryListController = {
        let layout = UICollectionViewFlowLayout()
        let controller = HistoryListController(collectionViewLayout: layout)
        return controller
    }()
 
}
