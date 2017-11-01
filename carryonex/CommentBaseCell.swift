//
//  CommentBaseCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/30.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class CommentBaseCell : UICollectionViewCell{
    
    
    var orderCommentPage : OrderCommentPage?
    var titleLabelWidthConstraint   : NSLayoutConstraint?
    var titleLabelCenterYConstraint : NSLayoutConstraint?
    
    var senderImgBtnWidthConstraint   : NSLayoutConstraint?
    var senderImgBtnCenterYConstraint : NSLayoutConstraint?
    
    var underlineViewBottomConstraint:NSLayoutConstraint?
    
    
    let underlineView = UIView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupUnderlineView()
        
    }
    
    private func setupUnderlineView(){
        underlineView.backgroundColor = .lightGray
        addSubview(underlineView)
        underlineView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
        underlineViewBottomConstraint = underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        underlineViewBottomConstraint?.isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


