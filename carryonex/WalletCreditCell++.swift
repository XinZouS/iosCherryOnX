//
//  WalletCreditCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


extension WalletCreditCell {
    
    func updateUIContentForCredit(){
        guard let cd = self.creditAccount else { return }
        
        cardTypeImageView.image = cd.imageOfAccountType(type: .VISA)
        infoLabel.text = cd.accountNumber
        
    }

    
    
    
    
}
