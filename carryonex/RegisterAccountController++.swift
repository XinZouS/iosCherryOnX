//
//  RegisterAccountController++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/5.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
extension RegisterAccountController: UITextFieldDelegate {
    func agreeCheckboxChanged(){
        let passwordRegisterCtl = PasswordRegisterController()
        self.present(passwordRegisterCtl, animated: true)
    }
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        emailTextField.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textField: UITextField) {
        transparentView.isHidden = false
        textField.becomeFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        textFieldsInAllCellResignFirstResponder()
        
    }
}
