//
//  OrderLogBaseCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

protocol OrderLogSenderCellDelegate {
    func updateCellStatusAndButtons()
}


extension OrderLogSenderCell {
    
    func updateUIContentsForRequest(){
        
        guard let rq = self.request else { return }
        
        if let statusId = rq.status?.id {
            switch statusId {
            case RequestStatus.waiting.rawValue:
                statusLabel.layer.borderColor = buttonThemeColor.cgColor
                statusLabel.textColor = buttonThemeColor
                statusLabel.backgroundColor = .white
                contactButton.isHidden = false
                let attributes : [String:Any] = [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                    NSForegroundColorAttributeName: UIColor.black
                ]
                let attributeString = NSAttributedString(string: "联系", attributes: attributes)
                contactButton.setAttributedTitle(attributeString, for: .normal)
                contactButton.addTarget(self, action: #selector(contactInfoButtonTapped), for: .touchUpInside)
                
            case RequestStatus.shipping.rawValue:
                statusLabel.layer.borderColor = UIColor.lightGray.cgColor
                statusLabel.textColor = .white
                statusLabel.backgroundColor = buttonThemeColor
                contactButton.isHidden = true
                
            case RequestStatus.finished.rawValue:
                statusLabel.layer.borderColor = UIColor.lightGray.cgColor
                statusLabel.textColor = .lightGray
                statusLabel.backgroundColor = pickerColorLightGray
                contactButton.isHidden = false
                let attributes : [String:Any] = [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                    NSForegroundColorAttributeName: UIColor.black
                ]
                let attributeString = NSAttributedString(string: "评价", attributes: attributes)
                contactButton.setAttributedTitle(attributeString, for: .normal)
                contactButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
            default:
                if let id = rq.status?.id, let description = rq.status?.description {
                    print("error::: get undefine status of Request: \(id): \(description)")
                }
            }
            updateCellStatusAndButtons()
        }
        
        requestIdLabel.text = "\(rq.id ?? -999)"
        itemsTextView.text = "<物品列表?>"
        costLabel.text = "$\(rq.totalValue ?? 0)"
        if let ecountry = rq.endAddress?.country, let ecity = rq.endAddress?.city {
            addressLabel.text = "往 \(ecountry), \(ecity)"
        }
    }
    
    
    func updateCellStatusAndButtons(){
        
        if let statusId = request?.status?.id {
            
            let attributes : [String:Any] = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: UIColor.black
            ]
            var attributeString = NSAttributedString()
            
            switch statusId {
            case RequestStatus.waiting.rawValue:
                statusLabel.text = "等待接单"
                attributeString = NSAttributedString(string: "详情", attributes: attributes)
                
            case RequestStatus.shipping.rawValue:
                statusLabel.text = "正在派送"
                attributeString = NSAttributedString(string: "追踪", attributes: attributes)
                
            case RequestStatus.finished.rawValue:
                statusLabel.text = "已经完成"
                attributeString = NSAttributedString(string: "详情", attributes: attributes)
                
            default:
                if let description = request?.status?.description {
                    print("error::: get undefine status of Request in OrderLogSenderCell::updateCellStatusAndButtons(): \(statusId) | \(description)")
                }
            }
            
            detailButton.setAttributedTitle(attributeString, for: .normal)
        }
    }
    
    func contactInfoButtonTapped(){
        print("TODO: contactInfoButtonTapped()...")
    }
    
    func commentButtonTapped(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let orderCommentPage = OrderCommentPage(collectionViewLayout: layout)
        ordersLogCtl?.navigationController?.pushViewController(orderCommentPage, animated: true)
    }
    
    func detailButtonTapped(){
        print("TODO: detailButtonTapped()...")
    }
    
}
