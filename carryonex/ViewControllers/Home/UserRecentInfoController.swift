//
//  UserRecentInfoController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/13.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class UserRecentInfoController: UIViewController{
    
    // title labels
    @IBOutlet weak var titleLabelTripCount: UILabel!
    @IBOutlet weak var titleLabelSendCount: UILabel!
    @IBOutlet weak var titleLabelComments: UILabel!
    
    // info contents
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
        setupTitleLabels()
    }
    
    private func setupTitleLabels() {
        titleLabelTripCount.text = L("home.ui.title.trip-count")
        titleLabelSendCount.text = L("home.ui.title.send-count")
        titleLabelComments.text = L("home.ui.title.comments")
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

