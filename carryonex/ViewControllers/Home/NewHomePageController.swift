//
//  NewHomePageController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/9.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import AlamofireImage

class NewHomePageController :UIViewController{
    
    @IBOutlet weak var userInfoButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var shipperButton: UIButton!
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var DetailInfoScrollerView: UIScrollView!
    
    override func viewDidLoad() {
        setupUserInfoButton()
        setupShipperButton()
        setupSenderButton()
    }
    
    private func setupUserInfoButton(){

    }
    
    private func setupShipperButton(){

    }
    
    private func setupSenderButton(){

    }
    
    @IBAction func userInfoButtonTapped(_ sender: Any) {
    }
}
