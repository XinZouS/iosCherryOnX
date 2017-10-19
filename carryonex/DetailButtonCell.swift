//
//  DetailButtonCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailButtonCell : DetailBaseCell{
    lazy var contactButton : UIButton = {
        let b = UIButton()
        b.setTitle("联系寄件人", for: .normal)
        b.backgroundColor = .clear
        b.setTitleColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), for: .normal)
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    let verticalLine : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 56: 60) // i5 < 400 < i6,7
        l.textAlignment = NSTextAlignment.center
        l.text = "|"
        l.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return l
    }()
    lazy var acceptButton : UIButton = {
        let b = UIButton()
        b.setTitle("接受订单", for: .normal)
        b.backgroundColor = .clear
        b.setTitleColor(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), for: .normal)
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupContactButton()
        setupAcceptButton()
        setupVerticalLine()
    }
    
    private func setupVerticalLine(){
        addSubview(verticalLine)
        verticalLine.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 80)
        titleLabelWidthConstraint = verticalLine.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
        titleLabelCenterYConstraint = verticalLine.centerXAnchor.constraint(equalTo: centerXAnchor)
        titleLabelCenterYConstraint?.isActive = true
    }
    
    private func setupContactButton(){
        addSubview(contactButton)
        contactButton.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 120, height: 90)
        senderImgBtnWidthConstraint = contactButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
    }
    
    private func setupAcceptButton(){
        addSubview(acceptButton)
        acceptButton.addConstraints(left: nil, top: topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 90, height: 90)
        senderImgBtnWidthConstraint = acceptButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
        senderImgBtnCenterYConstraint = acceptButton.centerXAnchor.constraint(equalTo: centerXAnchor,constant:80)
        senderImgBtnCenterYConstraint?.isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
