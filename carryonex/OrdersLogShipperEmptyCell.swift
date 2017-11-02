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
        b.font = UIFont.systemFont(ofSize: 14)
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
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = pickerColorLightGray
        
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
        
        let margin: CGFloat = 90
        addSubview(shareButton)
        shareButton.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: margin, topConstent: 0, rightConstent: margin, bottomConstent: 10, width: 0, height: 40)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



extension OrdersLogShipperEmptyCell {
    
    func shareButtonTapped(){
        ordersLogCtl?.navigationController?.pushViewController(WaitingController(), animated: true)
    }
    
    
}
