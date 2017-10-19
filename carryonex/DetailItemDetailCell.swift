//
//  DetailItemDetailCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailItemDetailCell : DetailBaseCell{
    let volumeLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        l.textAlignment = NSTextAlignment.center
        return l
    }()
    let weightLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        l.textAlignment = NSTextAlignment.center
        return l
    }()
    let verticalLine : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 48: 50) // i5 < 400 < i6,7
        l.textAlignment = NSTextAlignment.center
        l.text = "|"
        l.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return l
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVolumeLabel()
        setupWeightLabel()
        setupVerticalLine()
        backgroundColor = .white
        
    }
    
    private func setupVerticalLine(){
        addSubview(verticalLine)
        verticalLine.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
        titleLabelWidthConstraint = verticalLine.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
        titleLabelCenterYConstraint = verticalLine.centerXAnchor.constraint(equalTo: centerXAnchor)
        titleLabelCenterYConstraint?.isActive = true
    }
    private func setupVolumeLabel(){
        addSubview(volumeLabel)
        var volume = "体积:"
        volume = volume + "100"+"立方米"
        volumeLabel.text = volume
        volumeLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = volumeLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    
    private func setupWeightLabel(){
        addSubview(weightLabel)
        var weight = "重量:"
        weight = weight + "100"+"千克"
        weightLabel.text = weight
        weightLabel.addConstraints(left: nil, top: topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = weightLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
        titleLabelCenterYConstraint = weightLabel.centerXAnchor.constraint(equalTo: centerXAnchor,constant:80)
        titleLabelCenterYConstraint?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
