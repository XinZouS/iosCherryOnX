//
//  OrderListEmptyCell.swift
//  carryonex
//
//  Created by Zian Chen on 11/14/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderListEmptyCell: UITableViewCell {

    @IBOutlet weak var emptyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        emptyLabel.text = L("orders.ui.placeholder.youxiang-empty")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
