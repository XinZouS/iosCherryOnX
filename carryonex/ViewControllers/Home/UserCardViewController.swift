//
//  UserCardViewController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/14.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class UserCardViewController: UIViewController {
    
    @IBOutlet weak var UserStatus: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ItemDetailBtn: UIButton!
    @IBOutlet weak var ItemStatusBtn: UIButton!
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var BeginIconImage: UIImageView!
    @IBOutlet weak var endIconImage: UIImageView!
    
    var viewTag:Int = 0

    var listType: TripCategory = .carrier

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch viewTag{
        case 0:
            setupShipperCardView()
        default:
            listType = .sender
            setupSenderCardView()
        }
    }

    var profileInfo: HomeProfileInfo? {
        didSet {
            switch viewTag{
            case 0:
                setupShipperCardView()
            default:
                setupSenderCardView()
            }
        }
    }
    
    private func setupShipperCardView(){
        UserStatus.text = "我是出行人"
        
        if let profile = profileInfo {
            if let status = RequestStatus(rawValue: profile.request.statusId) {
                ItemStatusBtn.backgroundColor = status.displayColor(category: .carrier)
                ItemStatusBtn.setTitle(status.displayString(), for: .normal)
            }
            timeLabel.text = profile.trip.displayTime()
            beginLocationLabel.text = profile.trip.startAddress.fullAddressString()
            endLocationLabel.text = profile.trip.endAddress.fullAddressString()
            if let imageUrl = URL(string: profile.trip.image) {
                ItemDetailBtn.af_setImage(for: .normal, url: imageUrl)
            }
        }
    }
    
    private func setupSenderCardView(){
        UserStatus.text = "我是寄件人"
        if let profile = profileInfo {
            if let status = RequestStatus(rawValue: profile.request.statusId) {
                ItemStatusBtn.backgroundColor = status.displayColor(category: .sender)
                ItemStatusBtn.setTitle(status.displayString(), for: .normal)
            }
            timeLabel.text = profile.request.displayTime()
            beginLocationLabel.text = profile.request.startAddress.fullAddressString()
            endLocationLabel.text = profile.request.endAddress.fullAddressString()
            if let imageUrl = URL(string: profile.request.image) {
                ItemDetailBtn.af_setImage(for: .normal, url: imageUrl)
            }
        }
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.profileInfo = ProfileManager.shared.homeProfileInfo
        }
    }
}
