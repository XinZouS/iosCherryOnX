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
    @IBOutlet weak var statusButton1: UIButton!
    @IBOutlet weak var statusButton1WidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusButton2: UIButton!
    @IBOutlet weak var statusButton2WidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderCreditLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var sepratorImageView: UIImageView!
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
    

    @IBAction func statusButton1Tapped(_ sender: Any) {
    }
    
    @IBAction func statusButton2Tapped(_ sender: Any) {
    }
    
    
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
