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
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
    }
    
    private func addObservers(){
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.getUserRecentInfo()
        }
    }
    
    func getUserRecentInfo(){
        guard let profileInfo = ProfileManager.shared.homeProfileInfo else { return }
        shipTime.setTitle(String(profileInfo.tripCount), for: .normal)
        sendTime.setTitle(String(profileInfo.requestCount), for: .normal)
        generalCommentBtn.setTitle(String(format: "%.1f",profileInfo.rating), for: .normal)
        starViewWidth.constant = CGFloat(profileInfo.rating * 20)
    }
}

