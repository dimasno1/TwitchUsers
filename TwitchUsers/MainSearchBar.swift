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
        barStyle = .blackOpaque
        tintColor = secondTwitchColor
        keyboardAppearance = .dark
        showsCancelButton = true
        showsScopeBar = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
