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
        ItemStatusBtn.backgroundColor = #colorLiteral(red: 0.9794175029, green: 0.8914141059, blue: 0.4391655922, alpha: 1)
        ItemStatusBtn.setTitle("等待付款", for: .normal)
    }
    
    private func setupSenderCardView(){
        
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
    private func loadRecentTrip(){
        
    }
    private func loadRecentRequest(){
        
    }
}

