//
//  UserCardViewController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/14.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class UserCardViewController: NewHomePageController {
    @IBOutlet weak var UserStatus: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ItemDetailBtn: UIButton!
    @IBOutlet weak var ItemStatusBtn: UIButton!
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var BeginIconImage: UIImageView!
    @IBOutlet weak var endIconImage: UIImageView!
    var viewTag:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserUpdateNotificationObservers()
    }
    override func viewDidAppear(_ animated: Bool) {
        switch viewTag{
        case 0:
            setupShipperCardView()
        default:
            setupSenderCardView()
        }
    }
    
    private func setupShipperCardView(){
        UserStatus.text = "我是出行人"
        ItemStatusBtn.backgroundColor = #colorLiteral(red: 0.5483960509, green: 0.2370435894, blue: 0.8436982036, alpha: 1)
        setupButtonStyle()
    }
    
    private func setupSenderCardView(){
        setupButtonStyle()
        
    }
    private func addUserUpdateNotificationObservers(){
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            switch self?.viewTag{
            case 0?:
                self?.loadRecentTrip()
            default:
                self?.loadRecentRequest()
            }
        }
    }
    
    private func setupButtonStyle(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.ItemStatusBtn.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        switch timeStatus {
        case "night":
            let beginColor :UIColor = UIColor.MyTheme.mediumGreen
            let endColor :UIColor = UIColor.MyTheme.cyan
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        default:
            let beginColor :UIColor = UIColor.MyTheme.mediumGreen
            let endColor :UIColor = UIColor.MyTheme.cyan
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        }
        self.ItemStatusBtn.layer.insertSublayer(gradientLayer, at: 0)
    }
    private func loadRecentTrip(){

    }
    private func loadRecentRequest(){
        
    }
}
