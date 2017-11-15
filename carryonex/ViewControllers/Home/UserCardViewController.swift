//
//  UserCardViewController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/14.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class UserCardViewController: NewHomePageController{
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
    override func viewDidAppear(_ animated: Bool) {
        setupButtonStyle()
    }
    
    private func setupShipperCardView(){
        UserStatus.text = "我是出行人"
        BeginIconImage.image = #imageLiteral(resourceName: "shipperLocationIcon")
        endIconImage.image = #imageLiteral(resourceName: "shipperLocationIcon")
        ItemStatusBtn.backgroundColor = #colorLiteral(red: 0.5483960509, green: 0.2370435894, blue: 0.8436982036, alpha: 1)
    }
    
    private func setupSenderCardView(){
        
    }
    
    private func setupButtonStyle(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.ItemStatusBtn.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        switch timeStatus {
        case "night":
            let beginColor :UIColor = UIColor(red: 0.261000365, green: 0.6704152226, blue: 0.7383304834, alpha: 1)
            let endColor :UIColor = UIColor(red: 0.2490211129, green: 0.277058661, blue: 0.4886234403, alpha: 1)
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        default:
            let beginColor :UIColor = UIColor(red: 0.261000365, green: 0.6704152226, blue: 0.7383304834, alpha: 1)
            let endColor :UIColor = UIColor(red: 0.2490211129, green: 0.277058661, blue: 0.4886234403, alpha: 1)
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        }
        self.ItemStatusBtn.layer.insertSublayer(gradientLayer, at: 0)
    }
}
