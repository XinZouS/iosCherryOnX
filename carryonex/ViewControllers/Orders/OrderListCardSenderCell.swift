//
//  OrderListCardSenderCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/18/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderListCardSenderCell: OrderListCardCell {
    
    @IBOutlet weak var itemImageFrame2: UIImageView!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var itemNumLabel: UILabel!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var sepratorImageView: UIImageView!
    
    // card expand
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var shiperStarColorView: UIView!
    @IBOutlet weak var shiperNameLabel: UILabel!
    @IBOutlet weak var shiperScoreTitleLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var orderCodeLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var shiperStarColorConstraint: NSLayoutConstraint!
    
    //Buttons
    @IBOutlet weak var itemImageButton: UIButton!
    @IBOutlet weak var shiperProfileImageButton: UIButton!
    @IBOutlet weak var shiperPhoneCallButton: UIButton!
    
    @IBAction func handleSenderCellButton(sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellCategory = .sender
        statusLabel.textColor = UIColor.darkGray
    }
    
    override func updateRequestInfoAppearance(request: Request) {
        super.updateRequestInfoAppearance(request: request)
        
        shippingCostLabel.text = request.priceString()
        itemPriceLabel.text = request.itemValue()
        orderCodeLabel.text = "\(request.tripId)"
        
        if let shipperAddress = request.endAddress {
            shiperNameLabel.text = shipperAddress.recipientName
        }
        
        //TODO: Add phone call method
    }
    
    override func updateButtonAppearance(status: RequestStatus) {
        //Carrier
        switch status {
        case .waiting, .accepted:
            buttonsToShow = .twoButtons
        case .delivered, .deliveryConfirmed:
            buttonsToShow = .oneButton
        default:
            buttonsToShow = .noButtons
        }
        
        switch status {
        case .waiting:
            finishButton.transaction = .shipperCancel
            finishButton2.transaction = .shipperPairing
        case .accepted:
            finishButton.transaction = .shipperPay
            finishButton2.transaction = .shipperCancel
        case .delivered:
            finishButton.transaction = .shipperConfirm
        case .deliveryConfirmed:
            finishButton.setTitle(L("orders.ui.action.comment"), for: .normal) //TODO: need to see how it fits in.
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        sepratorImageView.isHidden = true
    }
}
