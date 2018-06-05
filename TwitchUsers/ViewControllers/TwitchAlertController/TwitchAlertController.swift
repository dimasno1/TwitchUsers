//
//  TwitchAlertController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/31/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class TwitchAlertController: UIViewController {
    
    var alertActions: [TwitchAlertAction]? {
        get {
            return twitchAlertActions
        }
    }
    
    func addActions(_ actions: TwitchAlertAction...) {
        actions.forEach { twitchAlertActions.append($0) }
    }
    
    override func viewWillLayoutSubviews() {
        alertView?.center = view.center
        alertView?.bounds.size = CGSize(width: 200, height: 300)
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
        self.init(title: title, message: message, with : nil)
    }
    
    convenience init(title: String?, message: String?, with backgroundImage: UIImage?) {
        self.init(nibName: nil, bundle: nil)
        self.titleLabel.text = title ?? "Title"
        self.messageLabel.text = message ?? "Message"
        self.backgroundImage = backgroundImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textAlignment = .center
        
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.textAlignment = .center
        
        buttonsStackView.axis = .vertical
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.layer.masksToBounds = true
        
        actionButtons = makeButtonsFromActions(array: twitchAlertActions)
        buttonsStackView.addArrangedSubviews(views: actionButtons)
        
        alertView = AlertView(titleView: titleLabel, messageView: messageLabel, buttonsStack: buttonsStackView, backgroundImage: backgroundImage)
        
        if alertView != nil {
            view.addSubview(alertView!)
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
    
    private var alertView: AlertView?
    private var backgroundImage: UIImage?
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let buttonsStackView = UIStackView()
    private var actionButtons = [UIButton]()
    private var twitchAlertActions = [TwitchAlertAction]()
}
