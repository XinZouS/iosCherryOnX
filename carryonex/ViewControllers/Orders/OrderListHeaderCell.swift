//
//  OrderListHeaderCell.swift
//  carryonex
//
//  Created by Zian Chen on 11/13/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderListHeaderCell: UITableViewCell {
    
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var trip: Trip? {
        didSet {
            if let fromCity = trip?.startAddress?.city,
                let fromCountry = trip?.startAddress?.country?.rawValue,
                let toCity = trip?.endAddress?.city,
                let toCountry = trip?.endAddress?.country?.rawValue {
                self.locationLabel.text = "\(fromCity), \(fromCountry) - \(toCity), \(toCountry)"
            }
            
            if let date = trip?.getDeliveryDateString() {
                self.dateLabel.text = date
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
