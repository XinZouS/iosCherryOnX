//
//  RequestInfoView++.swift
//  carryonex
//
//  Created by Xin Zou on 9/1/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension RequestInfoView {
    
    func setupLabelTextInfoFromRequest(){
        idLabel.text = labelTextList[0] + "\(request?.id ?? " ")"
        ownerLabel.text = labelTextList[1] + "\(request?.ownerUsername ?? " ")"
        costLabel.text = labelTextList[2] + "\(request?.cost ?? 0.0)"

        departatureLabel.text = labelTextList[3]
        departatureTextView.text = request?.startAddress?.descriptionString()
        
        destinationLabel.text = labelTextList[4]
        destinationTextView.text = request?.endAddress?.descriptionString()
        
        itemDetailLabel.text = labelTextList[5]
        expectDeliveryTimeLabel.text = labelTextList[6] //+ "\(request?.expectDeliveryTimeDescriptionString() ?? "none")"

        setupItemContents()
    }
    
    
    private func setupItemContents(){
        let itemMap = CategoryManager.shared.getFullMapById()
        
        if let items = request?.items {
            for item in items {
                if let categoryId = item.category?.id, let icon = itemMap[categoryId] {
                    let num = item.itemAmount
                    let itemDV = ItemDetailView() //(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
                    itemDV.setup(iconImg: icon, num: num)
                    
                    let v = UIView()
                    v.addSubview(itemDV)
                    itemDV.addConstraints(left: v.leftAnchor, top: v.topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 50, height: 30)
                    
                    self.itemDetailStackView.addArrangedSubview(v)
                }
            }
        }
        
    }
    
    
    
}
