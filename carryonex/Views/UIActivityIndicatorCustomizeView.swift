//
//  UIActivityIndicatorCustomizeView.swift
//  carryonex
//
//  Created by Xin Zou on 9/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class UIActivityIndicatorCustomizeView: UIView {
    
    let activityIndicator : UIActivityIndicatorView = {
        let v = UIActivityIndicatorView()
        v.activityIndicatorViewStyle = .white
        v.hidesWhenStopped = true
        return v
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.addSubview(activityIndicator)
        self.isHidden = true
    }
    
    init(frame: CGRect, bgColor: UIColor, cornerRadius: CGFloat) {
        super.init(frame: frame)
        
        self.backgroundColor = bgColor
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
        self.addSubview(activityIndicator)
        self.isHidden = true
    }
    
    
    func startAnimating(){
        self.isHidden = false
        activityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopAnimating(){
        DispatchQueue.main.async(execute: {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.isHidden = true
        })
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
