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
        
        switch rq.statusId{
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
            print("error::: get undefine status of Request: \(rq.statusId)")
        }
        
        updateCellStatusAndButtons()
        
        requestIdLabel.text = "\(rq.id ?? "")"
        
        itemsTextView.text = getStringFromRequest(rq)
        
        costLabel.text = "$\(rq.cost)"
        
        let addA = "\(rq.departureAddress!.country!),\(rq.departureAddress!.city!)"
        let addB = "\(rq.destinationAddress!.country!),\(rq.destinationAddress!.city!)"
        addressLabel.text = "\(addA)-->\(addB)"
    }
    
    
    private func getStringFromRequest(_ rq: Request) -> String {
        let mutableStr = NSMutableString()
        print("\(rq.numberOfItem)")
        for item in rq.numberOfItem {
            let name = item.key
            let num = "\(item.value)"
            print("\(name)*\(num), ")
            mutableStr.append("\(name)*\(num), ")
        }
        print("get mutableString = \(mutableStr)")
        return String(mutableStr)
    }
    
    
    func updateCellStatusAndButtons(){
        guard let rq = self.request else { return }
        
        let attributes : [String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.black
        ]
        var attributeString = NSAttributedString()
        
        switch rq.statusId{
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
            print("error::: get undefine status of Request in OrderLogSenderCell::updateCellStatusAndButtons(): \(rq.statusId)")
        }
        
        detailButton.setAttributedTitle(attributeString, for: .normal)
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
