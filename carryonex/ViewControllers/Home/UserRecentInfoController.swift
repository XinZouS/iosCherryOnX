//
//  UserRecentInfoController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/13.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

enum UserRecentInfoComponent {
    case tripCount
    case deliveryCount
    case score
}

protocol UserRecentInfoDelegate: class {
    func handleInfoButtonTapped(_ component: UserRecentInfoComponent)
}

class UserRecentInfoController: UIViewController{
    
    weak var delegate: UserRecentInfoDelegate?
    
    // title labels
    @IBOutlet weak var titleLabelTripCount: UILabel!
    @IBOutlet weak var titleLabelSendCount: UILabel!
    @IBOutlet weak var titleLabelComments: UILabel!
    
    // info contents
    @IBOutlet weak var starViewWidth: NSLayoutConstraint!
    @IBOutlet weak var star5MaskWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tripCountButton: UIButton!
    @IBOutlet weak var sendCountButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
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
    
    
    @IBAction func tripCountButtonTapped(_ sender: Any) {
        delegate?.handleInfoButtonTapped(.tripCount)
    }
    
    @IBAction func sendCountButtonTapped(_ sender: Any) {
        delegate?.handleInfoButtonTapped(.deliveryCount)
    }
    
    @IBAction func commentsButtonTapped(_ sender: Any) {
        delegate?.handleInfoButtonTapped(.score)
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
    
    public func getUserRecentInfo(){
        guard let profileInfo = ProfileManager.shared.homeProfileInfo else { return }
        tripCountButton.setTitle(String(profileInfo.tripCount), for: .normal)
        sendCountButton.setTitle(String(profileInfo.requestCount), for: .normal)
        commentsButton.setTitle(String(format: "%.1f", profileInfo.rating), for: .normal)
        let fullLength = star5MaskWidthConstraint.constant
        starViewWidth.constant = fullLength * CGFloat(profileInfo.rating / 5.0)
    }
}

