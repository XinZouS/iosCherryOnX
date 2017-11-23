//
//  OrderListCardSenderCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/18/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class OrderListCardSenderCell: UITableViewCell {
    
    @IBOutlet weak var itemImageFrame2: UIImageView!
    @IBOutlet weak var itemImageButton: UIButton!
    @IBOutlet weak var itemNumLabel: UILabel!
    
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var statusButton1: UIButton!
    @IBOutlet weak var statusButton1WidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusButton2: UIButton!
    @IBOutlet weak var statusButton2WidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sepratorImageView: UIImageView!
    // card expand
    @IBOutlet weak var ShiperProfileImageButton: UIButton!
    @IBOutlet weak var shiperNameLabel: UILabel!
    @IBOutlet weak var shiperPhoneCallButton: UIButton!
    @IBOutlet weak var shiperScoreTitleLabel: UILabel!
    @IBOutlet weak var shiperStarColorView: UIView!
    @IBOutlet weak var shiperStarColorConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var orderCodeLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    @IBOutlet weak var trackingButton: UIButton!
    
    
    
    @IBAction func statusButton1Tapped(_ sender: Any) {
    }
    
    @IBAction func statusButton2Tapped(_ sender: Any) {
    }
    
    var isStatusButton2Enable: Bool = true {
        didSet{
            statusButton2setup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isStatusButton2Enable = true // NOTE: change this value to hide btn
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        sepratorImageView.isHidden = !selected
    }
    


    private func statusButton2setup(){
        statusButton1WidthConstraint.constant = isStatusButton2Enable ? statusButton2WidthConstraint.constant : 100
        statusButton2.isEnabled = isStatusButton2Enable
        statusButton2.isHidden = !isStatusButton2Enable
    }

    
}

