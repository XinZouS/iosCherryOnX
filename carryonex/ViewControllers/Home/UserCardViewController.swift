//
//  UserCardViewController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/14.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

protocol UserCardDelegate: class {
    func userCardTapped(sender: UIButton, request: Request, category:TripCategory)
}

class UserCardViewController: UIViewController {
    
    @IBOutlet weak var UserStatus: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var requestImageView: UIImageView!
    @IBOutlet weak var ItemStatusBtn: UIButton!
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var BeginIconImage: UIImageView!
    @IBOutlet weak var endIconImage: UIImageView!
    
    var category: TripCategory?
    var request: Request? {
        didSet {
            setupCardView()
        }
    }
    
    weak var delegate: UserCardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ItemStatusBtn.isHidden = true
        self.view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapCard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCardView()
    }

    
    @objc private func handleTapCard(sender: UIButton) {
        guard let request = request, let category = category else { return }
        delegate?.userCardTapped(sender: sender, request: request, category: category)
    }
    
    private func setupCardView(){
        UserStatus.text = (self.category == .carrier) ? "出行订单" : "寄件订单"
        requestImageView.image = (self.category == .carrier) ? #imageLiteral(resourceName: "empty2") : #imageLiteral(resourceName: "empty1")
        beginLocationLabel.text = "暂时没有位置信息"
        endLocationLabel.text = "暂时没有位置信息"
        timeLabel.text = "无行程信息"
        guard let request = request, let category = category else {
            ItemStatusBtn.isHidden = true
            return
        }
        
        let status = request.status()
        ItemStatusBtn.isHidden = false
        ItemStatusBtn.backgroundColor = status.displayColor(category: category)
        ItemStatusBtn.setTitle(status.displayString(), for: .normal)
        
        if let trip = TripOrderDataStore.shared.getTrip(category: category, id: request.tripId) {
            timeLabel.text = trip.cardDisplayTime()
            beginLocationLabel.text = trip.startAddress?.fullAddressString()
            endLocationLabel.text = trip.endAddress?.fullAddressString()
            if request.images.count > 0, let imageUrl = URL(string: request.images[0].imageUrl) {
                if category == .carrier{
                    requestImageView.af_setImage(withURL: imageUrl, placeholderImage: #imageLiteral(resourceName: "empty1"))
                }else{
                    requestImageView.af_setImage(withURL: imageUrl, placeholderImage: #imageLiteral(resourceName: "empty2"))
                }
            }
        }
    }
}
