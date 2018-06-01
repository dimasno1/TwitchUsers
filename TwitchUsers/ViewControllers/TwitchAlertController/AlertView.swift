//
//  AlertView.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 6/1/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class AlertView: UIView {

    public convenience init(titleView: UIView?, messageView: UIView?, buttonsStack: UIStackView?) {
        self.init(frame: CGRect.zero)
        self.titleView = titleView
        self.messageView = messageView?
        self.buttonsStackView = buttonsStack?
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addSubviews(titleView, messageView, buttonsStackView)
    }
    
    private var titleView = UIView()
    private var messageView = UIView()
    private var buttonsStackView = UIStackView()
}
