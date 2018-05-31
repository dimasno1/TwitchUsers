//
//  FewFoundUsersViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/19/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit
import SnapKit

class UsersPageViewController: UIViewController{
    
    override func viewDidLoad() {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(dismissControllerWith(gestureRecognizer:)))
        view.addGestureRecognizer(recognizer)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareForAppearing()
    }
    
    func addAsChildViewContoller(profileViewController: ProfileViewController) {
        self.addChildViewController(profileViewController)
        profileViewController.willMove(toParentViewController: self)
        profileViewController.view.frame = self.view.bounds
        self.scrollView.addSubview(profileViewController.view)
        profileViewController.didMove(toParentViewController: self)
    }
    
    func setup(){
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = view.bounds
        view.addSubviews(scrollView, pageControl)
        pageControl.sizeToFit()
       
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(view.snp.bottom).offset(-20)
        }
        
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
        self.view.layer.shadowOpacity = 1.0
        self.view.layer.shadowRadius = 20
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        prepareForAppearing()
    }
    
    private func prepareForAppearing() {
        let width = self.view.bounds.size.width * CGFloat(childViewControllers.count)
        let height = self.view.bounds.size.height
        
        pageControl.numberOfPages = childViewControllers.count
        scrollView.contentSize = CGSize(width: width, height: height)
        scrollView.frame.size = view.bounds.size
        
        for controller in childViewControllers {
            guard let index = childViewControllers.index(of: controller) else { return }
            let originForChildController = CGPoint(x: CGFloat(index) * view.frame.size.width, y: 0)
            controller.view.frame.origin = originForChildController
        }
    }
    
    @objc private func dismissControllerWith(gestureRecognizer: UIPanGestureRecognizer) {
        let movedTranslation = gestureRecognizer.translation(in: view)
        let translationToMove = self.view.bounds.origin.y - movedTranslation.y
        if translationToMove < 0 {
            self.view.bounds.origin.y = translationToMove
        }
        
        switch gestureRecognizer.state {
        case .ended, .failed, .cancelled:
            let shouldScrollDown = self.view.bounds.origin.y.magnitude >= self.view.frame.size.height / 3
            if shouldScrollDown {
                UIView.animate(
                    withDuration: 0.5,
                    animations: { self.view.bounds.origin.y = -UIScreen.main.bounds.height },
                    completion: { _ in self.dismiss(animated: false, completion: nil) }
                )
            } else {
                UIView.animate(withDuration: 0.8) { self.view.bounds.origin.y = 0 }
            }
        default:
            break
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    private let scrollView = UIScrollView()
    private var pageControl = UIPageControl()
}


extension UsersPageViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let contentOffset = scrollView.contentOffset.x
        let pageNumber = Int(round(contentOffset/width))
        pageControl.currentPage = pageNumber
    }
}
