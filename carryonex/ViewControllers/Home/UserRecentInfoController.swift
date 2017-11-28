//
//  UserRecentInfoController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/13.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class UserRecentInfoController: UIViewController{
    
    @IBOutlet weak var starViewWidth: NSLayoutConstraint!
    @IBOutlet weak var generalCommentBtn: UIButton!
    @IBOutlet weak var shipTime: UIButton!
    @IBOutlet weak var sendTime: UIButton!
    @IBOutlet weak var levelImage: UIImageView!
    @IBOutlet weak var starView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
    }
    
    private func addNotificationObservers(){
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.getUserRecentInfo()
        }
    }
    
    func getUserRecentInfo(){
        guard let profileInfo = ProfileManager.shared.homeProfileInfo else { return }
        shipTime.setTitle(String(describing: profileInfo.tripCount), for: .normal)
        sendTime.setTitle(String(describing: profileInfo.requestCount), for: .normal)
        generalCommentBtn.setTitle(String(describing: profileInfo.rating), for: .normal)
        starViewWidth.constant = CGFloat(profileInfo.rating * 20)
    }
}

