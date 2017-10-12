//
//  WeightCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/21/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit




class WeightCell: RequestBaseCell {
    
    let weightUnitLabel : UILabel = {
        let l = UILabel()
        l.backgroundColor = .white
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .center
        l.text = "lb"
        return l
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(weightUnitLabel)
        weightUnitLabel.addConstraints(left: nil, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 26, height: 26)
        weightUnitLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let re = CGRect(x: 0, y: 0, width: 26, height: 20)
        let rightView = UILabel(frame: re)
        rightView.backgroundColor = .white
        textField.rightView = rightView
        textField.rightViewMode = .always
        textField.contentVerticalAlignment = .center
        
        textField.keyboardType = .numberPad
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

