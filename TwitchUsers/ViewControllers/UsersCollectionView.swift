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
    var usersCount: Int = 0
    let noUsersLabel = UILabel()
    var itemCounter = 0
    var notification: Notification?
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
        //MARK: Subscribe for notifications:
        
        notificationCenter.addObserver(forName: Notification.Name(rawValue: "AddedUser"), object: nil, queue: nil, using: {(notification) in
            self.notification = notification
            guard let userInfo = notification.userInfo else { return }
            guard let usersCount = userInfo["numberOfUsers"] as? Int else{ return }
            self.usersCount = usersCount
            print("Нашел пользователей: \(self.usersCount)")
            
            let indexPath = IndexPath(row: usersCount - 1, section: 0)
            print(indexPath)
            
            
            self.collectionView?.reloadData()
        })
    }
    
    convenience init(collectionViewLayout layout: UICollectionViewLayout, user: UserInfo) {
        self.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(noUsersLabel)
        noUsersLabel.isHidden = true
        collectionView?.backgroundColor = mainTwitchColor
        collectionView?.register(TwitchUserCell.self, forCellWithReuseIdentifier: TwitchUserCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
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
        print("usersCount: \(usersCount)")
        return usersCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwitchUserCell.identifier, for: indexPath) as! TwitchUserCell
        cell.layer.cornerRadius = 20
        
        guard let notification = self.notification else { return cell }
        guard let userInfo = notification.userInfo else { return cell }
        guard let user = userInfo["user"] as? UserInfo else { return cell }
        
        cell.photoFrame.image = user.avatar
        cell.nameLabel.text = user.name
        
        return cell
    }
    
    //MARK: CollectionView Delegate:
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let userForCurrentCell = users[indexPath.row]
        //        let vc = ProfileViewController(user: userForCurrentCell)
        //        present(vc, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("Selected")
        return true
    }
    
}
