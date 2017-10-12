//
//  RegisterEmailController++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit


extension RegisterEmailController: UITextFieldDelegate {
     func okButtonTapped(){
        let registerPasswordCtl = RegisterPasswordController()
        navigationController?.pushViewController(registerPasswordCtl, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextField) {
        transparentView.isHidden = false
        textView.becomeFirstResponder()
    }
    
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        emailTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        textFieldsInAllCellResignFirstResponder()
        
    }
}
