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
        if (isRegister) {
            let newPassword = passwordField.text ?? "123456"
            ProfileManager.shared.register(username: phoneInput, countryCode: zoneCodeInput, phone: phoneInput, password: newPassword, email: emailInput, completion: { (success) in
                if success {
                    isRegister = false
                    phoneInput = ""
                    zoneCodeInput = "1"
                    emailInput = ""
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.displayAlert(title: "不能注册", message: "注册出现错误，请再试一次。", action: "好")
                }
            })
        } else {
            print("改密码咯")
        }
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
            passwordCorrect = true
        }
        else{
            passwordField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            passwordField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            passwordField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            print("密码错误")
            passwordCorrect = false
        }
    }
    func checkConfirmPassword(){
        if passwordField.text == passwordConfirmField.text {
            print("密码正确")
            passwordConfirmField.leftViewActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            passwordConfirmField.dividerActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            passwordConfirmField.placeholderActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            if passwordCorrect == true{
                okButton.isEnabled = true
                okButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            }
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
    
}
