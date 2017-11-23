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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sepratorImageView: UIImageView!
    // card expand
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var shiperProfileImageButton: UIButton!
    @IBOutlet weak var shiperNameLabel: UILabel!
    @IBOutlet weak var shiperPhoneCallButton: UIButton!
    @IBOutlet weak var shiperScoreTitleLabel: UILabel!
    @IBOutlet weak var shiperStarColorView: UIView!
    @IBOutlet weak var shiperStarColorConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var orderCodeLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    // bottom buttons
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var finishButton2: UIButton!
    
        
    var finishButton2isEnable = false {
        didSet{
            finishButton2.isEnabled = finishButton2isEnable
            finishButton2.isHidden = !finishButton2isEnable
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        finishButton2isEnable = false // NOTE: change this value to hide btn
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        sepratorImageView.isHidden = !selected
    }
    

    
}

