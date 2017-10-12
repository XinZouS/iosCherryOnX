//
//  ButtonCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class ButtonCell: UITableViewCell {
    
    var addressCtl : AddressController!

    var idString: String!

    
    lazy var okButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        b.backgroundColor = buttonThemeColor
        b.setTitle("完成", for: .normal)
        return b
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupOkButton()
        
    }
    
    private func setupOkButton(){
        addSubview(okButton)
        okButton.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
