//
//  AddAccountCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class WalletAddingCell : WalletBaseCell {
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.textColor = .lightGray
        
        infoLabel.isHidden = true
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
