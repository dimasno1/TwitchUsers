//
//  ProfileViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/7/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{
    
    //MARK: Initialization:
    init(image: UIImage?, name: String, id: Int, type: String) {
        super.init(nibName: nil, bundle: nil)
        self.profileImageView.image = image
        nameView = self.setupTextViewWith(text: name, after: profileImageView)
        typeView = self.setupTextViewWith(text: type, after: nameView)
        idView = self.setupTextViewWith(text: String(id), after: typeView)
    }
    
    convenience init(user: UserInfo) {
        self.init(image: user.avatar ?? nil, name: user.name, id: user.id, type: user.type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ViewController lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(profileImageView)
        self.view.addSubview(closeButton)
        self.setup()
        
        let transform = CGAffineTransform(translationX: 0, y: -120)
        self.profileImageView.center = view.center.applying(transform)
        self.profileImageView.layer.masksToBounds = true
        
        if let image = profileImageView.image{
            let cornerRadius = image.size.width / 2
            self.profileImageView.layer.cornerRadius = cornerRadius
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let upperRightPoint = CGPoint(x: self.view.bounds.maxX, y: 0)
        let transform = CGAffineTransform(translationX: -50, y: 50)
        closeButton.frame.origin = upperRightPoint.applying(transform)
        closeButton.transform = closeButton.transform.rotated(by: CGFloat.pi/4)
    }
    
    @objc private func closeProfile(){
        removeThisContollerFromParentViewController(isChild: parent != nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTextViewWith(text: String, after previousView: UIView?) -> UITextView{
        
        let textView = UITextView()
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
        textView.isEditable = false
        textView.text = text
        textView.font = twitchFont
        textView.sizeToFit()
        self.view.addSubview(textView)
        
        let width = textView.frame.size.width
        let transform = CGAffineTransform(translationX: 0, y: 20)
        
        if let previousView = previousView, let superview = textView.superview{
            textView.frame.origin = CGPoint(x: superview.center.x - width/2, y: previousView.frame.maxY.advanced(by: 10))
        }else{
            textView.frame.origin = profileImageView.frame.origin.applying(transform)
        }
        return textView
    }
    
    private func setup(){
        self.view.backgroundColor = mainTwitchColor
        closeButton.tintColor = secondTwitchColor
        closeButton.addTarget(self, action: #selector(closeProfile), for: .touchUpInside)
        self.profileImageView.sizeToFit()
        self.closeButton.sizeToFit()
    }
    
    private func removeThisContollerFromParentViewController(isChild: Bool) {
        if isChild{
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    var profileImageView = UIImageView()
    var nameView =  UITextView()
    var typeView = UITextView()
    var idView = UITextView()
    private let closeButton = UIButton(type: UIButtonType.contactAdd)
    
}
