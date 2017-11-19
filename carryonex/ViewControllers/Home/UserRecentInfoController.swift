//
//  UserRecentInfoController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/13.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class UserRecentInfoController: UIViewController{
    
    @IBOutlet weak var generalCommentBtn: UIButton!
    @IBOutlet weak var shipTime: UIButton!
    @IBOutlet weak var sendTime: UIButton!
    var info: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserUpdateNotificationObservers()
    }
    private func addUserUpdateNotificationObservers(){
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.getUserRecentInfo()
        }
    }
    
    func getUserRecentInfo(){
         guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
        shipTime.setTitle(String(describing: currUser.tripCount), for: .normal)
        sendTime.setTitle(String(describing: currUser.requestCount), for: .normal)
        generalCommentBtn.setTitle(String(describing: currUser.rating), for: .normal)
    }
}
