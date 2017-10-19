//
//  DetailPriceCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailPriceCell : DetailBaseCell{
    let priceLabel : UILabel = {
        let l = UILabel()
        l.text = "运费报酬:"
        l.textAlignment = NSTextAlignment.center
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    let priceNumberLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = NSTextAlignment.center
        l.textColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 26 : 30) // i5 < 400 < i6,7
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPriceLabel()
        setupPriceNumberLabel()
        backgroundColor = .white
    }
    private func setupPriceNumberLabel(){
        addSubview(priceNumberLabel)
        priceNumberLabel.text = "$89"
        priceNumberLabel.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
        titleLabelCenterYConstraint = priceNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor,constant:80)
        titleLabelCenterYConstraint?.isActive = true
        titleLabelWidthConstraint = priceNumberLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    
    private func setupPriceLabel(){
        addSubview(priceLabel)
        priceLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = priceLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
