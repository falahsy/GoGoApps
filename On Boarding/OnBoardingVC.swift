//
//  OnBoardingVC.swift
//  cycle
//
//  Created by Syamsul Falah on 21/08/19.
//  Copyright © 2019 boy setiawan. All rights reserved.
//

import UIKit

class OnBoardingVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    var scrollViewWidth: CGFloat! = 0.0
    var scrollViewHeight: CGFloat! = 0.0
    
    var titles = ["Welcome to GoGo!","Easy Communication","Quick Connection"]
    var desc = ["An app that makes cycling with friends enjoyable and safer", "Help you to coordinate your community members during cycling together", "Connect to your Apple Watch so you can quickly send emergency signal"]
    var img = ["gowes rame","Group","Watch"]
    
    override func viewDidLayoutSubviews() {
        scrollViewWidth = scrollView.frame.size.width
        scrollViewHeight = scrollView.frame.size.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.layoutIfNeeded()
        nextButton.addTarget(self, action: #selector(showRegisVC), for: .touchUpInside)
        signInBtn.addTarget(self, action: #selector(showLoginVC), for: .touchUpInside)
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        scrollView.backgroundColor = UIColor(red: 233/255, green: 240/255, blue: 242/255, alpha: 1)
        
        for index in 0..<titles.count {
            frame.origin.x = scrollViewWidth * CGFloat(index)
            frame.size = CGSize(width: scrollViewWidth, height: scrollViewHeight)
            let slide = UIView(frame: frame)
            
            let imageView = UIImageView.init(image: UIImage.init(named: img[index]))
            imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x: scrollViewWidth/2, y: scrollViewHeight/2 - 50)
            
            let txt1 = UILabel.init(frame: CGRect(x: 32, y: imageView.frame.maxY+30, width: scrollViewWidth-64, height: 30))
            txt1.textAlignment = .center
            txt1.font = UIFont.boldSystemFont(ofSize: 30)
            txt1.text = titles[index]
            
            let txt2 = UILabel.init(frame: CGRect(x: 32, y: txt1.frame.maxY+10, width: scrollViewWidth-64, height: 50))
            txt2.textAlignment = .center
            txt2.numberOfLines = 3
            txt2.font = UIFont.systemFont(ofSize: 18.0)
            txt2.text = desc[index]
            
            slide.addSubview(imageView)
            slide.addSubview(txt1)
            slide.addSubview(txt2)
            scrollView.addSubview(slide)
        }
        
        scrollView.contentSize = CGSize(width: scrollViewWidth * CGFloat(titles.count), height: scrollViewHeight)
        
        self.scrollView.contentSize.height = 1.0
        
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
    }
    
    @IBAction func pageChanged(_ sender: Any){
        scrollView.scrollRectToVisible(CGRect(x: scrollViewWidth * CGFloat((pageControl?.currentPage)!), y: 0, width: scrollViewWidth, height: scrollViewHeight), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicatorForCurrentPage()
    }
    
    func setIndicatorForCurrentPage() {
        let page = (scrollView?.contentOffset.x)!/scrollViewWidth
        pageControl?.currentPage = Int(page)
    }
    
    @objc func showLoginVC() {
        let vc = LoginVC()
        vc.isLogin = true
        print(vc.isLogin!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showRegisVC() {
        let vc = LoginVC()
        vc.isLogin = false
        print(vc.isLogin!)
        navigationController?.pushViewController(vc, animated: true)
    }
}
