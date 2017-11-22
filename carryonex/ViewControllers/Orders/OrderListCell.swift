//
//  OrderListCell.swift
//  carryonex
//
//  Created by Zian Chen on 11/13/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {
    
    @IBOutlet var tripLabel: UILabel!
    @IBOutlet var ownerNameLabel: UILabel!
    @IBOutlet var endAddressLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var cellTypeLabel: UILabel!
    @IBOutlet var statusButton: UIButton!
    
    var cellType: TripCategory = .carrier {
        didSet {
            cellTypeLabel.text = (cellType == .carrier) ? "收件" : "寄件"
        }
    }
    
    var request: Request? {
        didSet {
            tripLabel.text = "\(request?.tripId ?? -999)"
            ownerNameLabel.text = request?.ownerUsername ?? "Unknown User"
            
            if let address = request?.endAddress {
                endAddressLabel.text = address.descriptionString()
            } else {
                endAddressLabel.text = "Bad address"
            }
            
            if let description = request?.description {
                descriptionLabel.text = description
            }
            
            if let price = request?.priceString() {
                priceLabel.text = price
            }
            
            //TODO: Update button
            statusButton.setTitle("更改状态", for: .normal)
            
            if let statusDescription = request?.status?.description {
                statusLabel.text = statusDescription
            }
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
