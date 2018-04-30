//
//  TwitchUserCell.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/29/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class TwitchUserCell: UICollectionViewCell{
    
    let photoFrame = UIImageView()
    let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    convenience init(frame: CGRect, image: UIImage, name: String) {
        self.init(frame: frame)
        photoFrame.image = image
        nameLabel.text = name
    }
    
    func setup(){
        self.contentView.addSubview(photoFrame)
        self.contentView.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
