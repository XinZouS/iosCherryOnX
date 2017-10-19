//
//  DetailCreditLevelCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailCreditLevelCell : DetailBaseCell{
    lazy var wechatButton : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 20
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Wechat_Icon"), for: .normal)
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var phoneButton : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 20
        b.backgroundColor = .white
        b.setImage(#imageLiteral(resourceName: "Carryonex_phone"), for: .normal)
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var facebookButton : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 20
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Facebook_Icon"), for: .normal)
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var messageButton : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 20
        b.setImage(#imageLiteral(resourceName: "carryonex_message"), for: .normal)
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupMessageBtn()
        setupPhoneBtn()
        setupWechatBtn()
        setupFacebookBtn()
        
    }
    private func setupMessageBtn(){
        addSubview(messageButton)
        messageButton.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 20, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 40, height: 40)
        senderImgBtnWidthConstraint = messageButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
    }
    
    private func setupPhoneBtn(){
        addSubview(phoneButton)
        phoneButton.addConstraints(left: nil, top: topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 40, height: 40)
        senderImgBtnWidthConstraint = phoneButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
        senderImgBtnCenterYConstraint = phoneButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant:-40)
        senderImgBtnCenterYConstraint?.isActive = true
    }
    private func setupWechatBtn(){
        addSubview(wechatButton)
        wechatButton.addConstraints(left: nil, top: topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 40, height: 40)
        senderImgBtnWidthConstraint = wechatButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
        senderImgBtnCenterYConstraint = wechatButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant:40)
        senderImgBtnCenterYConstraint?.isActive = true
    }
    private func setupFacebookBtn(){
        addSubview(facebookButton)
        facebookButton.addConstraints(left: nil, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 20, bottomConstent: 0, width: 40, height: 40)
        senderImgBtnWidthConstraint = facebookButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

