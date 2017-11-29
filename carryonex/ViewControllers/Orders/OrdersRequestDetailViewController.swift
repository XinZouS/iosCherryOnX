//
//  OrdersRequestDetailViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/29/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class OrdersRequestDetailViewController: UIViewController {
    
    // trip info
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    // request info
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var senderImageButton: UIButton!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderScoreWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemImage1: UIImageView!
    @IBOutlet weak var itemImage2: UIImageView!
    @IBOutlet weak var itemImageMoreButton: UIButton!
    @IBOutlet weak var youxiangCode: UILabel!
    // done buttons
    @IBOutlet weak var finishedButton: RequestTransactionButton!
    @IBOutlet weak var cancelButton: RequestTransactionButton!
    
    
    @IBAction func phoneButtonTapped(_ sender: Any) {
    }
    
    @IBAction func senderImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func itemImageMoreButtonTapped(_ sender: Any) {
    }
    
    @IBAction func youxiangShareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func finishedButtonTapped(_ sender: Any) {
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}


