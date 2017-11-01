//
//  OrdersLogShipperEmptyCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/1/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class OrdersLogShipperEmptyCell: UICollectionViewCell {
    
    var ordersLogCtl: OrdersLogController?
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.numberOfLines = 2
        b.textAlignment = .center
        b.textColor = .lightGray
        b.text = "你还没收到新的订单呢，\r快去分享你的行程给好友吧！"
        return b
    }()
    
    lazy var shareButton: UIButton = {
        let att = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        let str = NSAttributedString(string: "一键分享", attributes: att)
        let b = UIButton()
        b.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        b.setAttributedTitle(str, for: .normal)
        b.backgroundColor = buttonThemeColor
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 20
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = pickerColorLightGray
        
        let margin: CGFloat = 30
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: margin, topConstent: 10, rightConstent: margin, bottomConstent: 0, width: 0, height: 40)
        
        addSubview(shareButton)
        shareButton.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: margin, topConstent: 5, rightConstent: margin, bottomConstent: 5, width: 0, height: 0)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension OrdersLogShipperEmptyCell {
    
    func shareButtonTapped(){
        ordersLogCtl?.present(WaitingController(), animated: true, completion: nil)
    }
    
    
}
