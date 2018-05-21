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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("INITED FEWFOUNDUSERS")
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
    
        for controller in controllers{
            let index =  controllers.index(of: controller)
            switch index{
            case 0:
                controller.view.frame.origin = self.view.frame.origin
            case 1:
                controller.view.frame.origin = CGPoint(x:self.view.frame.maxX, y:0)
            case 2:
                controller.view.frame.origin = CGPoint(x:self.view.frame.maxX * 2, y:0)
            default:
                break
            }
            self.scrollView.addSubview(controller.view)
        }
    }
    
    func prepareForNewUsers(){
        controllers.removeAll()
        self.setup()
    }
    
    func addAsChildViewContoller(profileViewController: ProfileViewController) {
        self.addChildViewController(profileViewController)
        profileViewController.willMove(toParentViewController: self)
        self.view.addSubview(profileViewController.view)
    }
    
    private func setup(){
        let width = self.view.frame.size.width * CGFloat(controllers.count)
        let height = self.view.frame.size.height
        pageControl.numberOfPages = controllers.count
        scrollView.contentSize = CGSize(width: width, height: height)
    }
}


extension FewFoundUsersViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        let contentOffset = scrollView.contentOffset.x
        let pageNumber = Int(round(contentOffset/width))
        pageControl.currentPage = pageNumber
    }
}
