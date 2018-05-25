//
//  TwitchUserCell.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/29/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit
import SnapKit

let secondTwitchColor = UIColor(withFromZeroToRed: 31, green: 156, blue: 214)

class TwitchUserCell: UICollectionViewCell, UITextViewDelegate{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoFrame.image = nil
        nameLabel.text = nil
        bioTextView.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animate() {
        photoFrame.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        stackView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.photoFrame.transform = .identity
            self.stackView.alpha = 1
        }
    }
    
    private func setupCell() {
        
        self.photoFrame.layer.masksToBounds = true
        self.photoFrame.layer.shadowOpacity = 1
        self.photoFrame.layer.borderColor = UIColor.lightGray.cgColor
        self.photoFrame.layer.borderWidth = 2
        
        self.nameLabel.font = twitchFont
        self.nameLabel.adjustsFontSizeToFitWidth = true
        
        self.bioTextView.layer.cornerRadius = 10
        self.bioTextView.alpha = 0.7
        self.bioTextView.backgroundColor = .clear
        self.bioTextView.delegate = self
        self.bioTextView.isEditable = false
        self.bioTextView.textAlignment = .left
        
        self.contentView.alpha = 0.9
        self.contentView.layer.cornerRadius = 20
        
        contentView.addSubview(photoFrame)
        photoFrame.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(photoFrame.snp.height)
            make.left.equalToSuperview().offset(30)
        }
        
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.left.equalTo(photoFrame.snp.right).offset(30)
            make.right.equalToSuperview().offset(-30)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoFrame.setNeedsLayout()
        photoFrame.layoutIfNeeded()
        photoFrame.layer.cornerRadius = photoFrame.bounds.width / 2
    }
    
    static var identifier: String{
        return String(describing: self)
    }
    
    override var isHighlighted: Bool{
        didSet{
            UIView.animate(withDuration: 0.3) {
                self.contentView.backgroundColor = self.isHighlighted ? .white : nil
            }
        }
    }
    
    let photoFrame = UIImageView()
    let nameLabel = UILabel()
    let bioTextView = UITextView()
    private lazy var stackView = UIStackView(arrangedSubviews: [nameLabel, bioTextView])
}

