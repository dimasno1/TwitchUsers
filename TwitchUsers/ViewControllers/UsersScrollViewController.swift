//
//  FewFoundUsersViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/19/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit
import SnapKit

class UsersScrollViewController: UIViewController{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
        scrollView.frame = self.view.bounds
        view.addSubviews(scrollView, pageControl)
        pageControl.sizeToFit()
        pageControl.center.x = view.center.x
        pageControl.center.y = view.bounds.maxY - 30
    }
    
    private func prepareForAppearing() {
        let width = self.view.frame.size.width * CGFloat(childViewControllers.count)
        let height = self.view.frame.size.height
        pageControl.numberOfPages = childViewControllers.count
        scrollView.contentSize = CGSize(width: width, height: height)
        
        for controller in childViewControllers {
            guard let index = childViewControllers.index(of: controller) else { return }
            controller.view.frame.origin = CGPoint(x: CGFloat(index) * view.frame.size.width, y: 0)
        }
    }
    
    @objc private func dismissControllerWith(gestureRecognizer: UIPanGestureRecognizer) {
        let movedTranslation = gestureRecognizer.translation(in: view)
        let translationToMove = self.view.bounds.origin.y - movedTranslation.y
        if translationToMove < 0 {
            self.view.bounds.origin.y = translationToMove
        }
        
        switch gestureRecognizer.state {
        case .ended, .began, .cancelled:
            if self.view.bounds.origin.y.magnitude >= self.view.frame.size.height / 3{
                let queue = DispatchQueue.global(qos: .userInteractive)
                UIView.animate(withDuration: 1) { self.view.bounds.origin.y = -UIScreen.main.bounds.height }
                queue.asyncAfter(deadline: .now(), execute: { self.dismiss(animated: true, completion: nil) })
            }else{
                UIView.animate(withDuration: 1) { self.view.bounds.origin.y = 0 }
            }
        default:
            break
        }
        gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    private let scrollView = UIScrollView()
    private var pageControl = UIPageControl()
}


extension UsersScrollViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let contentOffset = scrollView.contentOffset.x
        let pageNumber = Int(round(contentOffset/width))
        pageControl.currentPage = pageNumber
    }
}