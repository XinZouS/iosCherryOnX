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
        addUserUpdateNotificationObservers()
    }
    override func viewDidAppear(_ animated: Bool) {
        switch viewTag{
        case 0:
            setupShipperCardView()
            setupInformation()
        default:
            listType = .sender
            setupSenderCardView()
            setupInformation()
        }
    }
    private func setupInformation(){
        ApiServers.shared.getUsersTrips(userType: listType, offset: 1, pageCount: 1) { (tripOrders, error) in
            
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            
            if let tripOrders = tripOrders {
                if tripOrders.count == 0{
                    print("There is no trip")
                }else{
                    if let startCountry = tripOrders[0].trip.startAddress?.country?.rawValue,let startState = tripOrders[0].trip.startAddress?.state,let startCity = tripOrders[0].trip.startAddress?.city,let endCountry = tripOrders[0].trip.endAddress?.country?.rawValue,let endState = tripOrders[0].trip.endAddress?.state,let endCity = tripOrders[0].trip.endAddress?.city{
                        self.beginLocationLabel.text = startCountry+" "+startState+" "+startCity
                        self.endLocationLabel.text = endCountry+" "+endState+" "+endCity
                    }
                }
            }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObservers()
    }
    
    private func setupShipperCardView(){
        UserStatus.text = "我是出行人"
        ItemStatusBtn.backgroundColor = #colorLiteral(red: 0.9794175029, green: 0.8914141059, blue: 0.4391655922, alpha: 1)
        ItemStatusBtn.setTitle("等待付款", for: .normal)
        if let profile = profileInfo {
            timeLabel.text = profile.trip.displayTime()
            beginLocationLabel.text = profile.trip.startAddress.homeCardDisplayString()
            endLocationLabel.text = profile.trip.endAddress.homeCardDisplayString()
            //if let imageUrl = URL(string: profile.trip.image) {   //TODO update this
            if let imageUrl = URL(string: "https://www.iaspaper.net/wp-content/uploads/2017/10/Rabbit-Essay.jpg") {
                ItemDetailBtn.af_setImage(for: .normal, url: imageUrl)
            }
        }
    }
    
    private func setupSenderCardView(){
        UserStatus.text = "我是寄件人"
        ItemStatusBtn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        ItemStatusBtn.setTitle("等待付款", for: .normal)
        
        if let profile = profileInfo {
            timeLabel.text = profile.request.displayTime()
            beginLocationLabel.text = profile.request.startAddress.homeCardDisplayString()
            endLocationLabel.text = profile.request.endAddress.homeCardDisplayString()
            //if let imageUrl = URL(string: profile.request.image) { //TODO update this
            if let imageUrl = URL(string: "https://www.iaspaper.net/wp-content/uploads/2017/10/Rabbit-Essay.jpg") {
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

