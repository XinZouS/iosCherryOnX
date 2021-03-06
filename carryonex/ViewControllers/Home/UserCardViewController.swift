//
//  UserCardViewController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/14.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

protocol UserCardDelegate: class {
    func userCardTapped(sender: UIButton, request: Request, category:TripCategory)
}

class UserCardViewController: UIViewController {
    
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var userStatusIcon: UIImageView!
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
            AppDelegate.shared().stopLoading()
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
        userStatus.text = (self.category == .carrier) ? L("home.ui.card.trip") : L("home.ui.card.send")
        userStatusIcon.image = (self.category == .carrier) ? #imageLiteral(resourceName: "home_shipper_cardicon") : #imageLiteral(resourceName: "home_sender_cardicon")
        requestImageView.image = (self.category == .carrier) ? #imageLiteral(resourceName: "logo_square") : #imageLiteral(resourceName: "logo_square")
        beginLocationLabel.text = L("home.ui.card.location-empty")
        endLocationLabel.text = L("home.ui.card.location-empty")
        timeLabel.text = L("home.ui.card.trip-empty")
        guard let request = request, let category = category else {
            ItemStatusBtn.isHidden = true
            return
        }
        
        let status = request.status()
        ItemStatusBtn.isHidden = false
        ItemStatusBtn.backgroundColor = status.displayColor(category: category)
        ItemStatusBtn.setTitleColor(status.displayTextColor(category: category), for: .normal)
        
        let title = status.displayString(isCommented: request.isCommented(category), isByExpress: request.isInExpress())
        ItemStatusBtn.setTitle(title, for: .normal)
        
        if let trip = TripOrderDataStore.shared.getTrip(category: category, id: request.tripId) {
            timeLabel.text = trip.cardDisplayTime()
            beginLocationLabel.text = trip.startAddress?.fullAddressString()
            endLocationLabel.text = trip.endAddress?.fullAddressString()
            if request.getImages().count > 0, let thumbnailUrl = URL(string: request.getImages().first!.thumbnailUrl) {
                if category == .carrier{
                    requestImageView.af_setImage(withURL: thumbnailUrl, placeholderImage: #imageLiteral(resourceName: "Loginnnnn"))
                }else{
                    requestImageView.af_setImage(withURL: thumbnailUrl, placeholderImage: #imageLiteral(resourceName: "Loginnnnn"))
                }
            }
        }
    }
}
