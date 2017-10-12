//
//  PasswordRegisterController++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/5.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

extension PasswordRegisterController: UITextFieldDelegate {
    func agreeCheckboxChanged(){
        let homePageCtl = HomePageController()
        self.present(homePageCtl, animated: true)
    }
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        passwordTextField.resignFirstResponder()
        passwordConfirmTextField.resignFirstResponder()
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
    func checkPassword(){
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)
        let maybePassword = passwordTextField.text
        if matcher.match(input: maybePassword!) {
            print("密码格式不正确")
        }else{
            print("密码格式正确")
        }
    }

}
