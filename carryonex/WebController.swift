//
//  WebController.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
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
    
    var activityIndicator: UIActivityIndicatorCustomizeView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupActivityIndicatorView()
    }
    
    private func setupWebView(){
        view.addSubview(webView)
        webView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: -160, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
    }
    
    private func loadWebpageFromUrl(){
        DispatchQueue.main.async {
            let request = URLRequest(url: self.url)
            self.webView.load(request)
            self.activityIndicator.startAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    private func setupActivityIndicatorView(){
        activityIndicator = UIActivityIndicatorCustomizeView() // UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
    }

}
