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
    
    //MARK: Initializition:
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
    
    private func setupCell(){
        
        self.contentView.alpha = 0.9
        self.contentView.layer.cornerRadius = 20
        
        self.photoFrame.center = self.contentView.center
        self.photoFrame.layer.masksToBounds = true
        self.photoFrame.layer.shadowOpacity = 1
        self.photoFrame.layer.borderColor = UIColor.lightGray.cgColor
        self.photoFrame.layer.borderWidth = 2
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.font = twitchFont
        self.nameLabel.adjustsFontSizeToFitWidth = true
        
        self.bioTextView.layer.cornerRadius = 10
        self.bioTextView.translatesAutoresizingMaskIntoConstraints = false
        self.bioTextView.alpha = 0.7
        self.bioTextView.backgroundColor = .clear
        self.bioTextView.delegate = self
        self.bioTextView.isEditable = false
        self.bioTextView.textAlignment = .left
      
        self.contentView.addSubview(photoFrame)
        
        self.getOnScreen(view: self.photoFrame, duration: 1, completion: { _ in
            self.contentView.addSubview(self.nameLabel)
            self.contentView.addSubview(self.bioTextView)
            self.makeConstraits()
        })
    }
    
    private func makeConstraits() {
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(photoFrame.snp.right).offset(20)
            make.top.equalTo(photoFrame.snp.top).offset(10)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
        
        bioTextView.snp.makeConstraints { make in
            make.left.equalTo(photoFrame.snp.right).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.bottom.equalTo(photoFrame.snp.bottom).offset(20)
            make.right.equalTo(contentView.snp.right).offset(-10)
        }
    }
    
    private func getOnScreen(view: UIView, duration: TimeInterval, completion: ((Bool)-> Void)?){
        let contentCenter = self.contentView.center
        let diameter = self.contentView.frame.size.width / 3
        let transformation = CGAffineTransform(translationX: -diameter + 20, y: 0)
        let newCenter = contentCenter.applying(transformation)
        view.center = newCenter
        
        DispatchQueue.main.async{
            UIView.animate(withDuration: duration,
                           animations: { view.layer.cornerRadius = diameter / 2
                                        view.frame.size = CGSize(width: diameter, height: diameter)
                                        view.center = newCenter },
                           completion: completion)
        }
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
}

