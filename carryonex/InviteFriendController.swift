//
//  InviteFriendController.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class InviteFriendController: WaitingController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = #imageLiteral(resourceName: "yadianwenqing")
        
        self.setupNavigationBar()
    }
    
    override func setupStatusBar() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func setupNavigationBar(){
        self.title = "邀请好友"
    }
    
    override func setupImageView(){
        let imageHW: CGFloat = view.bounds.width * 0.618
        view.addSubview(imageView)
        imageView.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: imageHW, height: imageHW)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
    }
    
    override func setupHintTextView(){
        hintTextView.isHidden = true
    }
    
    override func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


