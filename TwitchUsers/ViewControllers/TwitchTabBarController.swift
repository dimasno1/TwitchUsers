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
        resultsViewController.tabBarItem = tabBarItemForResultsView
        setup()
    }
    
    private func setup() {
        tabBar.barStyle = .black
        tabBar.tintColor = secondTwitchColor
        setViewControllers([searchViewController, resultsViewController], animated: true)
    }
    
    private let searchViewController = SearchViewController()
    private lazy var resultsViewController: HistoryOfSearchCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        let controller = HistoryOfSearchCollectionViewController(collectionViewLayout: layout)
        return controller
    }()
 
}
