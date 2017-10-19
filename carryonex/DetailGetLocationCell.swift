//
//  DetailGetLocationCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailGetLocationCell : DetailBaseCell{
    let getLocationLabel : UILabel = {
        let l = UILabel()
        l.text = "取货地址："
        l.textAlignment = NSTextAlignment.center
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    let LocationLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = NSTextAlignment.center
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGetLocationLabel()
        setupLocationLabel()
        backgroundColor = .white
    }
    private func setupLocationLabel(){
        addSubview(LocationLabel)
        LocationLabel.text = "424 Broadway 6 Floor"
        LocationLabel.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
        titleLabelCenterYConstraint = LocationLabel.centerXAnchor.constraint(equalTo: centerXAnchor,constant:60)
        titleLabelCenterYConstraint?.isActive = true
        titleLabelWidthConstraint = LocationLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 200 : 300)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupGetLocationLabel(){
        addSubview(getLocationLabel)
        getLocationLabel.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: 10, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = getLocationLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
