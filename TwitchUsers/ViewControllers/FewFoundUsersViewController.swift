//
//  FewFoundUsersViewController.swift
//  TwitchUsers
//
//  Created by Dimasno1 on 5/19/18.
//  Copyright © 2018 Dimasno1. All rights reserved.
//

import UIKit

class FewFoundUsersViewController: UIViewController{
    
    var controllers = [ProfileViewController]()
    let scrollView = UIScrollView()
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        view.addSubview(scrollView)
        view.addSubview(pageControl)
    }
   
    
    
    private func setup(){
        let width = self.view.frame.size.width * CGFloat(controllers.count)
        let height = self.view.frame.size.height
        pageControl.numberOfPages = controllers.count
        pageControl.sizeToFit()
        pageControl.center.x = view.center.x
        pageControl.center.y = view.bounds.maxY - 30
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize(width: width, height: height)
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
    }
}


extension FewFoundUsersViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.contentSize.width
        let contentOffset = scrollView.contentOffset.x
        let pageNumber = Int(round(contentOffset/width))
        pageControl.currentPage = pageNumber
    }
}
