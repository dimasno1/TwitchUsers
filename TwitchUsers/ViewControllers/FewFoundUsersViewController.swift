//
//  FewFoundUsersViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/19/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class FewFoundUsersViewController: UIViewController{
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        pageControl.sizeToFit()
        pageControl.center.x = view.center.x
        pageControl.center.y = view.bounds.maxY - 30
        scrollView.frame = self.view.bounds
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    func prepareForNewUsers(){
        self.setup()
    }
    
    func addAsChildViewContoller(profileViewController: ProfileViewController) {
        self.addChildViewController(profileViewController)
        profileViewController.willMove(toParentViewController: self)
        self.scrollView.addSubview(profileViewController.view)
        profileViewController.didMove(toParentViewController: self)
    }
    
    private func setup(){
        let width = self.view.frame.size.width * CGFloat(childViewControllers.count)
        let height = self.view.frame.size.height
        pageControl.numberOfPages = childViewControllers.count
        scrollView.contentSize = CGSize(width: width, height: height)
    }
    
    private let scrollView = UIScrollView()
    private var pageControl = UIPageControl()
}


extension FewFoundUsersViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let contentOffset = scrollView.contentOffset.x
        let pageNumber = Int(round(contentOffset/width))
        pageControl.currentPage = pageNumber
    }
}
