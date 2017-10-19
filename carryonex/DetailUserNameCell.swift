//
//  DetailUserNameCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/18.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailUserNameCell : DetailBaseCell {
    
    let nameLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "玖"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    let localLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "美国纽约"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    let youxiangLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "游箱号：1234"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    lazy var senderImgBtn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 40
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupNameLabel()
        setupLocalLabel()
        setupYouxiangLabel()
        setupSenderImgBtn()
        //        setupTextField()
        
    }
    private func setupSenderImgBtn(){
        addSubview(senderImgBtn)
        var imgName = "CarryonEx_Logo"
        senderImgBtn.setImage(UIImage(named: imgName), for: .normal)
        senderImgBtn.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 50, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 80, height: 80)
        senderImgBtnWidthConstraint = senderImgBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
    }
    private func setupNameLabel(){
        addSubview(nameLabel)
        nameLabel.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: 150, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupLocalLabel(){
        addSubview(localLabel)
        localLabel.addConstraints(left: leftAnchor, top: nameLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 150, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupYouxiangLabel(){
        addSubview(youxiangLabel)
        youxiangLabel.addConstraints(left: leftAnchor, top: localLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 150, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
