//
//  RecipientPhoneCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class RecipientPhoneCell : ZipcodeAndNameCell, ZipcodeCellDelegate {
    
    let countryCodeWidth: CGFloat = 80
    let textFieldTopMargin:CGFloat = 10
    let textFieldHeight: CGFloat = 30
    
    let countryCodeLabel: UILabel = {
        let 区号 = UILabel()
        区号.textAlignment = .center
        区号.layer.cornerRadius = 3
        区号.layer.masksToBounds = true
        区号.layer.borderColor = barColorLightGray.cgColor
        区号.backgroundColor = borderColorLightGray
        区号.text = flagsTitle[0] // flag and China
        return 区号
    }()
        

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCountryCodeLabel()
    }
    
    private func setupCountryCodeLabel(){
        addSubview(countryCodeLabel)
        countryCodeLabel.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: sideMargin, topConstent: textFieldTopMargin, rightConstent: 0, bottomConstent: 0, width: countryCodeWidth, height: textFieldHeight)
    }
    
    override func setupTextField() {
        addSubview(textField)
        textField.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: sideMargin + countryCodeWidth + 10, topConstent: textFieldTopMargin, rightConstent: 0, bottomConstent: 0, width: 175, height: textFieldHeight)
        textField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}



