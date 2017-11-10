//
//  CostCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/21/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class CostCell: RequestBaseCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textField.isHidden = true
        textField.allowsEditingTextAttributes = false
        textField.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
