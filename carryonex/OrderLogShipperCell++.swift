//
//  OrderLogSenderCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


extension OrderLogShipperCell: OrderLogSenderCellDelegate {

    
    override func updateCellStatusAndButtons() {
        
        guard let statusId = self.request?.status?.id else { return }
        
        let attributes : [String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
        ]
        var attributeString = NSAttributedString()
        
        switch statusId {
        case RequestStatus.waiting.rawValue:
            statusLabel.text = "等待出发"
            detailButtonWidthConstraint.constant = buttonWidthShort
            attributeString = NSAttributedString(string: "导航", attributes: attributes)
            
        case RequestStatus.inDelivery.rawValue:
            statusLabel.text = "正在途中"
            detailButtonWidthConstraint.constant = buttonWidthLong
            attributeString = NSAttributedString(string: "快递单号", attributes: attributes)
            
        case RequestStatus.delivered.rawValue:
            statusLabel.text = "已经完成"
            detailButtonWidthConstraint.constant = buttonWidthShort
            attributeString = NSAttributedString(string: "详情", attributes: attributes)
            
        default:
            print("error::: get undefine status of Request in OrderLogShipperCell::updateCellStatusAndButtons(): \(statusId)")
        }
        
        detailButton.setAttributedTitle(attributeString, for: .normal)
        
    }

}

