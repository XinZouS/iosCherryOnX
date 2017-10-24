//
//  RegisterPasswordController++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit


extension RegisterPasswordController: UITextFieldDelegate {
    func okButtonTapped(){
        isRegister = false
        alreadyExist = true
        let newPassword = passwordField.text
        let username = ProfileManager.shared.currentUser?.username
        let phone = ProfileManager.shared.currentUser?.phone
        let email = ProfileManager.shared.currentUser?.email
        // TODO: hash pw and upload to server
        ApiServers.shared.postRegisterUser(username: username!, phone: phone!, password: newPassword!, email: email!) { (isSuccess, msg) in
            if isSuccess == true{
                print(msg)
                self.dismiss(animated: true, completion: nil)
            }else{
                print(msg)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextField) {
        transparentView.isHidden = false
        textView.becomeFirstResponder()
    }
    func checkPassword(){
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)
        let maybePassword = passwordField.text
        if matcher.match(input: maybePassword!) {
            print("密码正确")
            passwordField.leftViewActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            passwordField.dividerActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            passwordField.placeholderActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
        else{
            passwordField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            passwordField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            passwordField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            print("密码错误")
        }
    }
    func checkConfirmPassword(){
        if passwordField.text == passwordConfirmField.text {
            print("密码正确")
            passwordConfirmField.leftViewActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            passwordConfirmField.dividerActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            passwordConfirmField.placeholderActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            okButton.isEnabled = true
            okButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        }
        else{
            passwordConfirmField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            passwordConfirmField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            passwordConfirmField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            print("密码错误")
            okButton.isEnabled = false
            okButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        passwordField.resignFirstResponder()
        passwordConfirmField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        textFieldsInAllCellResignFirstResponder()
        
    }
}
