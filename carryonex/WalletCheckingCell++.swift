//
//  WalletCheckingCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


extension WalletCheckingCell {
    
    func updateUIForAccountInfo(){
        guard let ck = self.checkingAccount else { return }
        
        titleLabel.text = ck.typeString
        infoLabel.text = ck.accountNumber
        
        
    }
    
    
    
    
    
}
