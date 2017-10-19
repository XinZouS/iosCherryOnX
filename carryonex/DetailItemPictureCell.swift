//
//  DetailItemPictureCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailItemPictureCell : DetailBaseCell{
    let nameLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "物品图片:"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    let picture1Btn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 30
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    let picture2Btn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 30
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    let picture3Btn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 30
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupNameLabel()
        setupPicture1Btn()
        setupPicture2Btn()
        setupPicture3Btn()
        backgroundColor = .white
        
    }

    private func setupNameLabel(){
        addSubview(nameLabel)
        nameLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupPicture1Btn(){
        addSubview(picture1Btn)
        var imgName = "CarryonEx_Logo"
        picture1Btn.setImage(UIImage(named: imgName), for: .normal)
        picture1Btn.addConstraints(left: leftAnchor, top: nameLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 20, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 60, height: 60)
        senderImgBtnWidthConstraint = picture1Btn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
    }
    private func setupPicture2Btn(){
        addSubview(picture2Btn)
        var imgName = "CarryonEx_Logo"
        picture2Btn.setImage(UIImage(named: imgName), for: .normal)
        picture2Btn.addConstraints(left: nil, top: nameLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 60, height: 60)
        senderImgBtnWidthConstraint = picture2Btn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
        senderImgBtnCenterYConstraint = picture2Btn.centerXAnchor.constraint(equalTo: centerXAnchor)
        senderImgBtnCenterYConstraint?.isActive = true
    }
    private func setupPicture3Btn(){
        addSubview(picture3Btn)
        var imgName = "CarryonEx_Logo"
        picture3Btn.setImage(UIImage(named: imgName), for: .normal)
        picture3Btn.addConstraints(left: nil, top: nameLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 20, bottomConstent: 0, width: 60, height: 60)
        senderImgBtnWidthConstraint = picture3Btn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
