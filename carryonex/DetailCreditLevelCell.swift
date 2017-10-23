//
//  DetailCreditLevelCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import MessageUI

class DetailCreditLevelCell : DetailBaseCell,MFMessageComposeViewControllerDelegate{
    let CreditLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    lazy var phoneButton : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 20
        b.backgroundColor = .white
        b.setImage(#imageLiteral(resourceName: "Carryonex_phone"), for: .normal)
        b.addTarget(self, action: #selector(phoneButtonTap), for: .touchUpInside)
        return b
    }()
    
    lazy var messageButton : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 20
        b.setImage(#imageLiteral(resourceName: "carryonex_message"), for: .normal)
        b.backgroundColor = .white
        b.addTarget(self, action: #selector(MessageButtonTap), for: .touchUpInside)
        return b
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupCreditLevel()
        setupMessageBtn()
        setupPhoneBtn()
        
    }
    private func setupCreditLevel(){
        addSubview(CreditLabel)
        let title = "5"
        CreditLabel.text = "信用等级:"+title
        CreditLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = CreditLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupMessageBtn(){
        addSubview(messageButton)
        messageButton.addConstraints(left: nil, top: nil, right: rightAnchor, bottom: nil, leftConstent: nil, topConstent: 0, rightConstent: 20, bottomConstent: 0, width: 40, height: 40)
        senderImgBtnWidthConstraint = messageButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
    }
    
    private func setupPhoneBtn(){
        addSubview(phoneButton)
        phoneButton.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 40, height: 40)
        senderImgBtnWidthConstraint = phoneButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
        senderImgBtnCenterYConstraint = phoneButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant:40)
        senderImgBtnCenterYConstraint?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

