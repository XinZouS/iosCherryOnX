//
//  CheckingCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class WalletCheckingCell : WalletBaseCell {
    
    override var checkingAccount : CheckingAccount! {
        didSet{
            updateUIForAccountInfo()
        }
    }
    
    
}
