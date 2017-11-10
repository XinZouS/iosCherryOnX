//
//  RequestInfoView++.swift
//  carryonex
//
//  Created by Xin Zou on 9/1/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

extension RequestInfoView {
    
    func setupLabelTextInfoFromRequest() {
        idLabel.text = labelTextList[0] + "\(request?.id ?? " ")"
        ownerLabel.text = labelTextList[1] + "\(request?.ownerUsername ?? " ")"
        costLabel.text = labelTextList[2] + "\(request?.totalValue ?? 0)"

        departatureLabel.text = "出发地 (移除此Label)"
        departatureTextView.text = "出发地（移除此TextView)"
        
        destinationLabel.text = labelTextList[4]
        destinationTextView.text = request?.endAddress?.descriptionString()
        
        itemDetailLabel.text = labelTextList[5]
        expectDeliveryTimeLabel.text = labelTextList[6] //+ "\(request?.expectDeliveryTimeDescriptionString() ?? "none")"
    }
}
