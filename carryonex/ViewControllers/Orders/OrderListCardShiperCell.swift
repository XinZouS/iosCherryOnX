//
//  OrderListCardCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/16/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderListCardShiperCell: OrderListCardCell {
    
    // order card
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var orderCreditLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var sepratorImageView: UIImageView!
    // card expand
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderStarColorView: UIView!
    @IBOutlet weak var senderStarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var itemListImageView1: UIImageView!
    @IBOutlet weak var itemListImageView2: UIImageView!
    @IBOutlet weak var itemListImageMoreButton: UIButton!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    @IBOutlet weak var youxiangCodeShareButton: UIButton!
    
    private var cellType: TripCategory = .carrier
    
    override func updateRequestInfoAppearance(request: Request) {
        super.updateRequestInfoAppearance(request: request)
    }
    
    override func updateButtonAppearance(status: RequestStatus) {
        //Carrier
        switch status {
        case .waiting, .paid, .pendingRefund, .inDelivery:
            buttonsToShow = .twoButtons
        case .accepted, .delivered:
            buttonsToShow = .oneButton
        default:
            buttonsToShow = .noButtons
        }
        
        switch status {
        case .waiting:
            finishButton.transaction = .carrierAccept
            finishButton2.transaction = .carrierReject
        case .accepted:
            finishButton.transaction = .carrierCancel
        case .paid:
            finishButton.transaction = .carrierReceive
            finishButton2.transaction = .carrierRefund
        case .pendingRefund:
            finishButton.transaction = .carrierRefund
            finishButton2.transaction = .carrierDeliver  //TODO: ASK.
        case .inDelivery:
            finishButton.transaction = .carrierShip
            finishButton2.transaction = .carrierRefund
        case .delivered:
            finishButton.setTitle("给与评价", for: .normal) //TODO: need to see how it fits in.
        default:
            print("No actions attached")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        sepratorImageView.isHidden = !selected
    }
}
