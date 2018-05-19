//
//  UsersCollectionView.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class UsersCollectionView: UICollectionViewController{
    
    let notificationCenter = NotificationCenter.default
    let noUsersLabel = UILabel()
    var users = [UserInfo]()
    
    //MARK: Initialization:
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        //MARK: Subscribe for notifications:
        notificationCenter.addObserver(forName: Notification.Name(rawValue: "AddedUser"), object: nil, queue: nil, using: {(notification) in
            guard let userInfo = notification.userInfo, let user = userInfo["user"] as? UserInfo else { return }
            self.users.append(user)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK Controller Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        setupParametersOf(label: noUsersLabel)
        self.view.addSubview(noUsersLabel)
        collectionView?.backgroundColor = mainTwitchColor
        collectionView?.register(TwitchUserCell.self, forCellWithReuseIdentifier: TwitchUserCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
        noUsersLabel.isHidden = users.count > 0 ? true : false
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    private func setupParametersOf(label: UILabel){
        label.font = twitchFont
        label.text = "Try to search for user"
        let labelSize = label.sizeThatFits(view.bounds.size)
        label.frame.size = labelSize.applying(CGAffineTransform(scaleX: 0.8, y: 0.8))
        label.adjustsFontSizeToFitWidth = true
        label.center = self.view.center
        label.isHidden = false
    }
    
    //MARK: CollectionView DataSource:
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwitchUserCell.identifier, for: indexPath) as! TwitchUserCell
        cell.layer.cornerRadius = 20
        let user = self.users[indexPath.row]
        
        cell.bioTextView.text = user.bio ?? "No bio provided by user"
        cell.photoFrame.image = user.avatar
        cell.nameLabel.text = user.name
        
        return cell
    }
    
    //MARK: CollectionView Delegate:
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userForCurrentCell = users[indexPath.row]
        let vc = ProfileViewController(user: userForCurrentCell)
        present(vc, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
