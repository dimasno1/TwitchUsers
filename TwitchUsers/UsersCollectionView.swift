//
//  UsersCollectionView.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class UsersCollectionView: UICollectionViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(TwitchUserCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TwitchUserCell
        cell.layer.cornerRadius = 20
        cell.nameLabel.text = "Some"
        cell.backgroundColor = .darkGray
        return cell
    }
    
}
