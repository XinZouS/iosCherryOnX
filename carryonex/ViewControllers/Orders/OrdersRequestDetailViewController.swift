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
    @IBOutlet weak var senderPhoneButton: UIButton!
    @IBOutlet weak var senderImageButton: UIButton!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderScoreWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemImage1: UIImageView!
    @IBOutlet weak var itemImage2: UIImageView!
    @IBOutlet weak var itemImageMoreButton: UIButton!
    @IBOutlet weak var itemValueLabel: UILabel!
    @IBOutlet weak var itemMessageTextView: UITextView!
    // recipient info
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientPhoneLabel: UILabel!
    @IBOutlet weak var recipientPhoneCallButton: UIButton!
    @IBOutlet weak var recipientAddressLabel: UILabel!
    // done buttons
    @IBOutlet weak var finishedButton: RequestTransactionButton!
    @IBOutlet weak var cancelButton: RequestTransactionButton!
    
    
    @IBAction func senderPhoneButtonTapped(_ sender: Any) {
    }
    
    @IBAction func senderImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func itemImageMoreButtonTapped(_ sender: Any) {
    }
    
    @IBAction func recipientPhoneCallButtonTapped(_ sender: Any) {
    }
    // done buttons
    @IBAction func finishedButtonTapped(_ sender: Any) {
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    
    // MARK: -
    var trip: Trip?
    var request: Request?
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
}


