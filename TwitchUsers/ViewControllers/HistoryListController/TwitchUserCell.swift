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
    
    let photoFrame = UIImageView()
    let nameLabel = UILabel()
    let bioTextView = UITextView()
    let removeButton = UIButton()
    
    enum State {
        case editing
        case identity
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoFrame.setNeedsLayout()
        photoFrame.layoutIfNeeded()
        photoFrame.layer.cornerRadius = photoFrame.bounds.width / 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoFrame.image = nil
        nameLabel.text = nil
        bioTextView.text = nil
        removeButton.imageView?.image = nil
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func animate() {
        photoFrame.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        textStackView.alpha = 0
        UIView.animate(withDuration: 1,
                       animations:
            { [weak photoFrame, textStackView] in
                photoFrame?.transform = .identity
                textStackView.alpha = 1
                photoFrame?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                photoFrame?.transform = .identity
                photoFrame?.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            },
                       completion: { _ in
                        UIView.animate(withDuration: 0.5) {
                            self.photoFrame.layer.transform = CATransform3DIdentity
                        }
        })
    }
    
    func animateForCurrentState(state: State) {
        switch state {
        case .editing:
            self.removeButton.isHidden = false
            self.removeButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 1) {
                self.removeButton.transform = .identity
            }
        case .identity:
            self.removeButton.isHidden = true
            UIView.animate(withDuration: 1) {
                self.removeButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
        }
    }
    
    private func setupCell() {
        photoFrame.layer.masksToBounds = true
        photoFrame.layer.shadowOpacity = 1
        photoFrame.layer.borderColor = UIColor.lightGray.cgColor
        photoFrame.layer.borderWidth = 2
        
        nameLabel.font = twitchFont
        nameLabel.adjustsFontSizeToFitWidth = true
        
        bioTextView.layer.cornerRadius = 10
        bioTextView.alpha = 0.7
        bioTextView.backgroundColor = .clear
        bioTextView.delegate = self
        bioTextView.isEditable = false
        bioTextView.textAlignment = .left
        
        contentView.alpha = 0.9
        contentView.layer.cornerRadius = 20
        contentView.addSubview(photoFrame)
        
        photoFrame.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalTo(photoFrame.snp.height)
            make.left.equalToSuperview().offset(30)
        }
        
        fullStackView.spacing = 20
        fullStackView.axis = .horizontal
        fullStackView.distribution = .fillProportionally
        fullStackView.alignment = .center
        fullStackView.contentMode = .scaleToFill
        
        textStackView.spacing = 0
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.distribution = .fillEqually
        
        contentView.addSubview(fullStackView)
        
        fullStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.left.equalTo(photoFrame.snp.right).offset(30)
            make.right.equalToSuperview().offset(-30)
        }
        
        removeButton.setImage(UIImage(named: "removeButton.png"), for: .normal)
        removeButton.snp.makeConstraints { make in
            make.height.equalTo(photoFrame).multipliedBy(0.3)
            make.width.equalTo(removeButton.snp.height)
        }
        removeButton.isHidden = true
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
    
    private lazy var textStackView = UIStackView(arrangedSubviews: [nameLabel, bioTextView])
    private lazy var fullStackView = UIStackView(arrangedSubviews: [textStackView, removeButton])
}

