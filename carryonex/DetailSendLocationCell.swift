//
//  DetailSendLocationCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailSendLocationCell : DetailBaseCell{
    let sendLocationLabel : UILabel = {
        let l = UILabel()
        l.text = "送货地址:"
        //        l.backgroundColor = .cyan
        l.textAlignment = NSTextAlignment.center
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    let textView : UITextView = {
        let v = UITextView()
        v.isEditable = false
        v.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        v.borderColor = .clear
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSendLocationLabel()
        setupTextView()
        backgroundColor = .white
    }
    
    private func setupTextView(){
        addSubview(textView)
        textView.text = "中国上海嘉定区五月花广场1-2收件人手机号18717788655邮编2300001"
        textView.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 200, height: 80)
        titleLabelCenterYConstraint = textView.centerXAnchor.constraint(equalTo: centerXAnchor,constant:60)
        titleLabelCenterYConstraint?.isActive = true
        titleLabelWidthConstraint = textView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 200 : 300)
        titleLabelWidthConstraint?.isActive = true
    }
    
    private func setupSendLocationLabel(){
        addSubview(sendLocationLabel)
        sendLocationLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = sendLocationLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
