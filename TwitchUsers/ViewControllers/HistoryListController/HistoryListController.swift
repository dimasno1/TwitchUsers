//
//  UsersCollectionView.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/28/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit
import SnapKit

class HistoryListController: UICollectionViewController{
    
    var users = [Meta]()
    
    enum State {
        case empty
        case nonEmpty
    }
    
    enum EditingState {
        case editing
        case standart
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        subsribeForNotifications()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK Controller Lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noUsersLabel)
        view.addSubview(editButton)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editButton.isHidden = state == .nonEmpty ? false : true
        noUsersLabel.isHidden = users.count > 0 ? true : false
        guard let cells = collectionView?.visibleCells as? [TwitchUserCell] else { return }
        cells.forEach{cell in cell.animate()}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        editingState == .editing ? switchEditingState() : nil
    }
    
    //MARK: CollectionView DataSource:
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TwitchUserCell.identifier, for: indexPath) as! TwitchUserCell
        let user = self.users[indexPath.row]
        
        cell.layer.cornerRadius = 20
        cell.bioTextView.text = user.bio ?? "No bio provided by user"
        cell.photoFrame.image = user.avatar
        cell.nameLabel.text = user.name
        cell.animate()
        
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
    
    @objc func switchEditingState() {
        guard let cells = collectionView?.visibleCells as? [TwitchUserCell] else { return }
        editingState = editingState == .editing ? .standart : .editing
        switch editingState {
        case .editing:
            cells.forEach {$0.animateForCurrentState(state: .editing)}
        case .standart:
            cells.forEach {$0.animateForCurrentState(state: .identity)}
        }
    }
    
    private func setupParametersOf(label: UILabel){
        label.font = twitchFont
        label.text = "Try to search for user"
        label.textColor = .gray
        let labelSize = label.sizeThatFits(view.bounds.size)
        label.frame.size = labelSize.applying(CGAffineTransform(scaleX: 0.8, y: 0.8))
        label.adjustsFontSizeToFitWidth = true
        label.center = self.view.center
        label.isHidden = false
    }
    
    private func makeConstraits() {
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
        }
    }
    
    private func setup() {
        makeConstraits()
        setupParametersOf(label: noUsersLabel)
        editButton.setTitle("Edit", for: .normal)
        editButton.isHidden = true
        editButton.addTarget(self, action: #selector(switchEditingState), for: .touchUpInside)
        collectionView?.backgroundColor = mainTwitchColor
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(TwitchUserCell.self, forCellWithReuseIdentifier: TwitchUserCell.identifier)
    }
    
    private func subsribeForNotifications() {
        
        tokens.append(notificationCenter.addObserver(forName: .searchHistoryAdd, object: nil, queue: nil, using: {(notification) in
            guard let userInfo = notification.userInfo, let user = userInfo["user"] as? Meta else { return }
            self.collectionView?.performBatchUpdates({
                self.users.append(user)
                let index = IndexPath(item: self.users.count - 1, section: 0)
                self.collectionView?.insertItems(at: [index])
            }, completion: nil)
            self.state = .nonEmpty
        }))
        
        tokens.append(notificationCenter.addObserver(forName: .searchHistoryRemove, object: nil, queue: nil, using: { (notification) in
            guard let userInfo = notification.userInfo, let user = userInfo["user"] as? Meta else { return }
            if self.users.contains(user) {
                guard let removingUserIndex = self.users.index(of: user) else { return }
                self.users.remove(at: removingUserIndex)
                self.state = self.users.count < 1 ? .empty : .nonEmpty
                self.collectionView?.reloadData()
            }
        }))
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var state: State = .empty
    private var editingState: EditingState = .standart
    private let noUsersLabel = UILabel()
    private let notificationCenter = NotificationCenter.default
    private let editButton = UIButton(type: UIButtonType.system)
    private var tokens: Array<NSObjectProtocol> = []
}


//FlowLayoutDelegate:
extension HistoryListController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.size.width - 20
        let height = self.view.bounds.size.height / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

