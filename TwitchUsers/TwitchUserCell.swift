//
//  TwitchUserCell.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 4/29/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

let secondTwitchColor = UIColor(withFromZeroToRed: 31, green: 156, blue: 214)

class TwitchUserCell: UICollectionViewCell, UITextViewDelegate{
    
    let photoFrame = UIImageView()
    let nameLabel = UILabel()
    let bioTextView = UITextView()
    var hashForUser: Int?
    
    //MARK: Initializition:
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoFrame.image = nil
        nameLabel.text = nil
        hashForUser = nil
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
        self.photoFrame.layer.borderColor = UIColor.white.cgColor
        self.photoFrame.layer.borderWidth = 2
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.font = twitchFont
        self.nameLabel.adjustsFontSizeToFitWidth = true
        
        self.bioTextView.layer.cornerRadius = 10
        self.bioTextView.translatesAutoresizingMaskIntoConstraints = false
        self.bioTextView.alpha = 0.7
        self.bioTextView.backgroundColor = .clear
        self.bioTextView.delegate = self
        self.bioTextView.textAlignment = .left
        
        self.contentView.addSubview(photoFrame)
        self.contentView.addSubview(bioTextView)
        
        self.getOnScreen(view: self.photoFrame, duration: 1, completion: {
            
            self.contentView.addSubview(self.nameLabel)
            self.contentView.addSubview(self.bioTextView)
            
            self.nameLabel.leadingAnchor.constraint(equalTo: self.photoFrame.trailingAnchor, constant: 20).isActive = true
            self.nameLabel.topAnchor.constraint(equalTo: self.photoFrame.topAnchor, constant: 10).isActive = true
            self.nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
            
            self.bioTextView.leftAnchor.constraint(equalTo: self.photoFrame.rightAnchor, constant: 20).isActive = true
            self.bioTextView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5).isActive = true
            self.bioTextView.bottomAnchor.constraint(equalTo: self.photoFrame.bottomAnchor, constant: 20).isActive = true
            self.bioTextView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        })
    }
    
    private func getOnScreen(view: UIView, duration: TimeInterval, completion: @escaping ()-> Void){
        let contentCenter = self.contentView.center
        let diameter = self.contentView.frame.size.width / 3
        let transformation = CGAffineTransform(translationX: -diameter + 20, y: 0)
        let newCenter = contentCenter.applying(transformation)
        view.center = newCenter
        
        DispatchQueue.main.async{
            UIView.animate(withDuration: duration){
                view.layer.cornerRadius = diameter / 2
                view.frame.size = CGSize(width: diameter, height: diameter)
                view.center = newCenter
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: completion)
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
 
    private let deviceScaleFactor = UIScreen.main.scale
}

