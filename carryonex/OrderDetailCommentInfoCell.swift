//
//  OrderDetailCommentInfoCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class OrderDetailCommentInfoCell : OrderDetailCommentBaseCell {
    
    var nameLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    var timeLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    lazy var senderImgBtn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 40
        b.layer.masksToBounds = true
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    
    var commentTextView : UITextView = {
        let v = UITextView()
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupNameLabel()
        setupTimeLabel()
        setupSenderImgBtn()
        setupCommentView()
        setupUnderlineView()
        //        setupTextField()
        
    }
    private func setupSenderImgBtn(){
        addSubview(senderImgBtn)
        senderImgBtn.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 50, topConstent: 20, rightConstent: 0, bottomConstent: 0, width: 80, height: 80)
        senderImgBtnWidthConstraint = senderImgBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
    }
    private func setupNameLabel(){
        addSubview(nameLabel)
        nameLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 150, topConstent: 30, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupTimeLabel(){
        addSubview(timeLabel)
        timeLabel.addConstraints(left: leftAnchor, top: nameLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 150, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupCommentView(){
        addSubview(commentTextView)
        commentTextView.addConstraints(left: leftAnchor, top: senderImgBtn.bottomAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: UIScreen.main.bounds.width, height: 30)
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