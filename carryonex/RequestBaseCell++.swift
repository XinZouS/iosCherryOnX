//
//  RequestBaseCell++.swift
//  carryonex
//
//  Created by Xin Zou on 8/24/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension RequestBaseCell : UITextFieldDelegate {
        
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        textField.resignFirstResponder()
    }
    
    
}

