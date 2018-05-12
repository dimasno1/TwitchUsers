//
//  UsersCollectionView.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class UsersCollectionView: UICollectionViewController{
    
    var user: UserInfo?
  
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    convenience init(collectionViewLayout layout: UICollectionViewLayout, user: UserInfo) {
        self.init(collectionViewLayout: layout)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(TwitchUserCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TwitchUserCell
        cell.layer.cornerRadius = 20
        guard let currentUser = self.user else { return cell }
        cell.nameLabel.text = currentUser.name
        cell.backgroundColor = secondTwitchColor
        cell.photoFrame.image = currentUser.avatar
        
        return cell
    }
    
}
