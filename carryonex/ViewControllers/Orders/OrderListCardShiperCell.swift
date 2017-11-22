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
    @IBOutlet weak var orderStatusLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var cardSeparatorImageView: UIImageView!
    // card expand
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
    @IBOutlet weak var finishButton: UIButton!
    

    
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
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    
}
