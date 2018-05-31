//
//  ProfileViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/7/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController{
    
    var stackView = UIStackView()
    var profileImageView = UIImageView()
    var nameView =  UITextView()
    var typeView = UITextView()
    var idView = UITextView()
    
    
    //MARK: Initialization:
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(image: UIImage?, name: String, id: String, type: String) {
        super.init(nibName: nil, bundle: nil)
        self.profileImageView.image = image
        nameView = self.setupTextViewWith(text: name)
        typeView = self.setupTextViewWith(text: type)
        idView = self.setupTextViewWith(text: id)
    }
    
    convenience init(user: Meta) {
        self.init(image: user.avatar ?? nil, name: user.name, id: user.id, type: user.type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: ViewController lifecycle:
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        closeButton.isHidden = parent != nil ? true : false
    }
    
    @objc private func closeProfile(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func removeThisContollerFromParentViewController(isChild: Bool) {
        if isChild{
            self.willMove(toParentViewController: nil)
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
    
    private func setup(){
        view.addSubviews(stackView, profileImageView, closeButton)
        view.backgroundColor = mainTwitchColor
        setupStackView(stackView: stackView, with: [nameView, idView, typeView])
        makeConstraits()
        
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        profileImageView.layer.masksToBounds = true
        if let image = profileImageView.image{
            let cornerRadius = image.size.width / 2
            profileImageView.layer.cornerRadius = cornerRadius
        }
        
        closeButton.transform = closeButton.transform.rotated(by: CGFloat.pi/4)
        closeButton.tintColor = secondTwitchColor
        closeButton.addTarget(self, action: #selector(closeProfile), for: .touchUpInside)
    }
    
    private func makeConstraits() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Contstant.topOffset)
            make.centerX.equalToSuperview()
            
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.left.equalTo(profileImageView)
            make.right.equalTo(profileImageView)
            make.bottom.equalTo(view).offset(-20)
        }
        closeButton.snp.makeConstraints { make in
            make.right.equalTo(view).offset(-10)
            make.top.equalTo(view).offset(10)
        }
    }
    
    private func setupTextViewWith(text: String) -> UITextView{
        let textView = UITextView()
        textView.backgroundColor = self.view.backgroundColor
        textView.textColor = .black
        textView.isEditable = false
        textView.textAlignment = .center
        textView.text = text
        textView.font = twitchFont
        return textView
    }
    
    private func setupStackView(stackView: UIStackView, with arrangedSubviews: [UIView]) {
        stackView.addArrangedSubviews(views: arrangedSubviews)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    deinit {
        removeThisContollerFromParentViewController(isChild: parent != nil)
    }
    
    private let scaleFactor = UIScreen.main.scale
    private let closeButton = UIButton(type: UIButtonType.contactAdd)
}


//Extensions:
extension UIStackView {
    func addArrangedSubviews(views: [UIView]) {
        for view in views{
            self.addArrangedSubview(view)
        }
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview(_:))
    }
}

extension ProfileViewController {
    struct Contstant {
        static let topOffset: CGFloat = 20
        static let sideOffset: CGFloat = 10
        static let someOffset: CGFloat = 20
    }
}
