//
//  AlertView.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 6/1/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    public convenience init(titleView: UIView, messageView: UIView, buttonsStack: UIStackView, backgroundImage: UIImage?) {
        
        self.init(frame: CGRect.zero)
        self.titleView = titleView
        self.messageView = messageView
        self.buttonsStackView = buttonsStack
        self.backgroundImageView.image = backgroundImage
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = mainTwitchColor
        center = superview?.center ?? CGPoint.zero
        bounds.size = CGSize(width: 300, height: 300)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addSubviews(backgroundImageView, titleView, messageView, buttonsStackView)
        makeConstraits()
        setup()
    }
    
    private func makeConstraits() {
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        messageView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: AlertView.topOffsetConstant).isActive = true
        titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: AlertView.heightConstant).isActive = true
        
        messageView.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        messageView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        messageView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        messageView.heightAnchor.constraint(equalToConstant: AlertView.heightConstant).isActive = true
        
        buttonsStackView.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: AlertView.topOffsetConstant).isActive = true
        buttonsStackView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor).isActive = true
        buttonsStackView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor).isActive = true
        buttonsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    private func setup() {
        
        clipsToBounds = true
        layer.cornerRadius = AlertView.cornerRadiusConstant
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.cornerRadius = AlertView.cornerRadiusConstant
        backgroundImageView.clipsToBounds = true
        
    }
    
    private let backgroundImageView = UIImageView()
    private var titleView = UIView()
    private var messageView = UIView()
    private var buttonsStackView = UIStackView()
}

extension AlertView {
    
    static let heightConstant: CGFloat = 40
    static let topOffsetConstant: CGFloat = 10
    static let cornerRadiusConstant: CGFloat = 30
}
