//
//  TwitchTabBarController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/13/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class TwitchTabBarController: UITabBarController{
    
    let searchViewController = SearchViewController()
    
    let resultsViewController: UsersCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UIScreen.main
        layout.itemSize = CGSize(width: view.bounds.size.width - 20, height: view.bounds.size.height / 3)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        let controller = UsersCollectionView(collectionViewLayout: layout)
        
        return controller
    }()
    
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
    
    
    
}
