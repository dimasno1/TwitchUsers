//
//  TwitchAlertController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/31/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit
import SnapKit

class TwitchAlertController: UIViewController {
    
    var alertActions: [TwitchAlertAction]? {
        get {
            return twitchAlertActions
        }
    }
    
    func addActions(_ actions: TwitchAlertAction...) {
        actions.forEach { twitchAlertActions.append($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    convenience init(title: String?, message: String?) {
        self.init(title: title, message: message, backgroundImage: nil)
    }
    
    convenience init(title: String?, message: String?, backgroundImage: UIImage?) {
        self.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title ?? "Title"
        self.messageLabel.text = message ?? "Message"
        self.backgroundImageView.image = backgroundImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        view.addSubview(alertView)
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.layer.shadowOffset = CGSize(width: 9, height: 9)
        titleLabel.layer.shadowRadius = 12
        titleLabel.layer.shadowOpacity = 1
        titleLabel.textAlignment = .center
        
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.layer.shadowOffset = CGSize(width: 9, height: 9)
        messageLabel.layer.shadowRadius = 12
        messageLabel.layer.shadowOpacity = 1
        messageLabel.textAlignment = .center
        
        alertView.center = view.center
        alertView.backgroundColor = mainTwitchColor
        alertView.layer.cornerRadius = 30
        alertView.bounds.size = CGSize(width: 200, height: 300)
        
        buttonsStackView.axis = .vertical
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.layer.masksToBounds = true
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.layer.cornerRadius = 30
        backgroundImageView.clipsToBounds = true
        
        actionButtons = makeButtonsFromActions(array: twitchAlertActions)
        buttonsStackView.addArrangedSubviews(views: actionButtons)
        
        if (backgroundImageView.image != nil){
            alertView.addSubview(backgroundImageView)
        }
        
        alertView.addSubviews(titleLabel, messageLabel)
    
        if  !buttonsStackView.arrangedSubviews.isEmpty {
            alertView.addSubview(buttonsStackView)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.bottom.equalTo(titleLabel.snp.top).offset(20)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.bottom.equalTo(messageLabel.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func makeButtonsFromActions(array: [TwitchAlertAction]) -> [UIButton] {
        var buttons = [UIButton]()
        var counter = 0
        for action in array { 
            let button = UIButton(type: .roundedRect)
            button.setTitle(action.twitchAlertTitle, for: .normal)
            button.setTitleColor(action.style.color(), for: .normal)
            button.tag = counter
            counter += 1
            buttons.append(button)
            button.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
        }
        return buttons
    }
    
    @objc private func buttonClicked(sender: UIButton) {
        let tag = sender.tag
        let actionForSender = twitchAlertActions[tag]
        actionForSender.executeHandler()
    }
    
    private var handler: (() -> Void)?
    private var alertView = UIView()
    private var backgroundImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonsStackView = UIStackView()
    private var actionButtons = [UIButton]()
    private var twitchAlertActions = [TwitchAlertAction]()
}
