//
//  WebController.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController, WKNavigationDelegate {
    
    var url: URL! {
        didSet{
            loadWebpageFromUrl()
        }
    }
    
    lazy var webView : WKWebView = {
        let w = WKWebView()
        w.navigationDelegate = self
        return w
    }()
    
    var activityIndicator: BPCircleActivityIndicator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupActivityIndicatorView()
        setupNavigationBar()
    }
    
    private func setupWebView(){
        view.addSubview(webView)
        webView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: -160, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
    }
    
    private func setupNavigationBar(){
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    
    private func loadWebpageFromUrl(){
        DispatchQueue.main.async {
            let request = URLRequest(url: self.url)
            self.webView.load(request)
            self.activityIndicator?.isHidden = false
            self.activityIndicator?.animate()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator?.isHidden = true
        activityIndicator?.stop()
    }
    
    private func setupActivityIndicatorView(){
        activityIndicator = BPCircleActivityIndicator()
        activityIndicator?.center = CGPoint(x: view.center.x - 15, y: view.center.y - 60)
        activityIndicator?.isHidden = true
        if let a = activityIndicator {
            view.addSubview(a)
        }
    }

}
