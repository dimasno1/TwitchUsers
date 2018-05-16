//
//  TwitchUserCell.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/29/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

let secondTwitchColor = UIColor(withFromZeroToRed: 31, green: 156, blue: 214)

class TwitchUserCell: UICollectionViewCell{
    
    static var identifier: String{
        return String(describing: self)
    }
    
    override var isHighlighted: Bool{
        didSet{
            UIView.animate(withDuration: 0.3) {
                self.contentView.backgroundColor = self.isHighlighted ? secondTwitchColor : nil
            }
        }
    }
    
    let photoFrame = UIImageView()
    let nameLabel = UILabel()
    
    
    //MARK: Initializition:
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCell()
    }
    
    convenience init(frame: CGRect, image: UIImage, name: String) {
        self.init(frame: frame)
        photoFrame.image = image
        nameLabel.text = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell(){
        
        self.contentView.layer.cornerRadius = 20
        self.photoFrame.center = self.contentView.center
        self.contentView.addSubview(photoFrame)
        self.photoFrame.layer.masksToBounds = true
        self.photoFrame.layer.shadowOpacity = 1
        self.photoFrame.layer.borderColor = UIColor.white.cgColor
        self.photoFrame.layer.borderWidth = 2
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.font = twitchFont
        
        UIView.commitAnimations()
        
        self.getOnScreen(view: self.photoFrame, duration: 1, completion: {
            self.contentView.addSubview(self.nameLabel)
            self.nameLabel.leadingAnchor.constraint(equalTo: self.photoFrame.trailingAnchor, constant: 20).isActive = true
            self.nameLabel.topAnchor.constraint(equalTo: self.photoFrame.topAnchor, constant: 10).isActive = true
            self.nameLabel.sizeToFit()
        })
    }
    
    private func getOnScreen(view: UIView, duration: TimeInterval, completion: @escaping ()-> Void){
        let contentCenter = self.contentView.center
        let width = self.contentView.frame.size.width / 3
        let height = width
        let transformation = CGAffineTransform(translationX: -width + 20, y: 0)
        let newCenter = contentCenter.applying(transformation)
        view.center = newCenter
        
        DispatchQueue.main.async{
            UIView.animate(withDuration: duration){
                view.layer.cornerRadius = height / 2
                view.frame.size = CGSize(width: width, height: height)
                view.center = newCenter
            }
        
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: completion)
    }
}

