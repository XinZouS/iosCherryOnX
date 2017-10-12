//
//  RecipientPhoneCell++.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension RecipientPhoneCell{
    
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        addressCtl.transparentView.isHidden = false
        textField.becomeFirstResponder()
    }
    
    func buttonTapped(){
        print("recipientPhone cell buttonTapped")
        
    }
    
    
}



