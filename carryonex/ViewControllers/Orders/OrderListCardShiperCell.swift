//
//  OrderListCardCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/16/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit



class OrderListCardShiperCell: UITableViewCell {
    
    
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
    // bottom buttons
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var finishButton2: UIButton!
    
    
    var cellType: TripCategory = .carrier {
        didSet {
            //TODO:change this: cellTypeLabel.text = (cellType == .carrier) ? "收件" : "寄件"
        }
    }
    
    var request: Request? {
        didSet{
            //TODO: setup cell info
        }
    }
    
    var finishButton2isEnable = true {
        didSet{
            finishButton2.isEnabled = finishButton2isEnable
            finishButton2.isHidden = !finishButton2isEnable
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        finishButton2isEnable = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        sepratorImageView.isHidden = !selected
    }
    
    
}
