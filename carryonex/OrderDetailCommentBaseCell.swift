//
//  OrderDetailCommentBaseCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class OrderDetailCommentBaseCell : UICollectionViewCell{
    
    var orderDetailCommentPageCtl : OrderDetailCommentPageController?
    var titleLabelWidthConstraint   : NSLayoutConstraint?
    var titleLabelCenterYConstraint : NSLayoutConstraint?
    
    var senderImgBtnWidthConstraint   : NSLayoutConstraint?
    var senderImgBtnCenterYConstraint : NSLayoutConstraint?
    
    var underlineViewBottomConstraint:NSLayoutConstraint?
    
    
    let underlineView = UIView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

