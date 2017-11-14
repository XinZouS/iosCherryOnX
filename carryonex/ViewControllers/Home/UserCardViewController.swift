//
//  UserCardViewController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/14.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class UserCardViewController: UIViewController{
    @IBOutlet weak var UserStatus: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ItemDetailBtn: UIButton!
    @IBOutlet weak var ItemStatusBtn: UIButton!
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var BeginIconImage: UIImageView!
    @IBOutlet weak var endIconImage: UIImageView!
    override func viewDidLoad() {
        switch viewTag{
        case 0:
            setupShipperCardView()
        default:
            setupSenderCardView()
        }
        viewTag += 1
    }
    
    private func setupShipperCardView(){
        UserStatus.text = "我是出行人"
        BeginIconImage.image = #imageLiteral(resourceName: "shipperLocationIcon")
        endIconImage.image = #imageLiteral(resourceName: "shipperLocationIcon")
        ItemStatusBtn.backgroundColor = #colorLiteral(red: 0.5483960509, green: 0.2370435894, blue: 0.8436982036, alpha: 1)
    }
    private func setupSenderCardView(){
    }
}
