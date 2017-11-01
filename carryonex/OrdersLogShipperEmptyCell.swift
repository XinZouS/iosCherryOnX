//
//  OrdersLogShipperEmptyCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/1/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class OrdersLogShipperEmptyCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.numberOfLines = 2
        b.textColor = .lightGray
        b.text = "you have no Request yet, share your youxiang code to get orders!"
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = pickerColorLightGray
        
        let margin: CGFloat = 20
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: margin, topConstent: margin, rightConstent: margin, bottomConstent: margin, width: 0, height: 0)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
