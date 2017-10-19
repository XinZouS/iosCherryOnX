//
//  ZipcodeAndNameCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class ZipcodeAndNameCell : UITableViewCell {
    
    var addressCtl : AddressController!

    var idString: String!

    let sideMargin : CGFloat = 30

    let titleLabel: UILabel = {
        let b = UILabel()
        b.text = ""
        b.textAlignment = .left
        b.textColor = .black
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
        
    let textField: UITextField = {
        let t = UITextField()
        t.backgroundColor = .white
        t.layer.borderColor = borderColorLightGray.cgColor
        t.layer.borderWidth = 1
        t.layer.cornerRadius = 3
        t.layer.masksToBounds = true
        t.font = UIFont.systemFont(ofSize: 16)
        t.keyboardType = .numberPad
        t.returnKeyType = .done
        return t
    }()
    

    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTitle()
        setupTextField()
    }
    
    private func setupTitle(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: sideMargin, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 160, height: 20)
    }
    
    public func setupTextField() {
        addSubview(textField)
        textField.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: sideMargin, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 210, height: 30)
        textField.delegate = self
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
