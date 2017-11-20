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
        if isRegister {
            let newPassword = passwordField.text ?? "123456"
            ProfileManager.shared.register(username: phoneInput, countryCode: zoneCodeInput, phone: phoneInput, password: newPassword, email: emailInput, completion: { (success, msg, tag) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    if let msg = msg {
                        let m = "注册出现错误，请再试一次。\(msg)"
                        self.displayAlert(title: "不能注册", message: m, action: "好")
                    }
                }
            })
        } else {
            print("TODO: RegisterPasswordController change password in Server: 改密码咯")
        }
    }
    
    func checkPassword(){
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)
        let maybePassword = passwordField.text
        
        passwordCorrect = matcher.match(input: maybePassword!)
        passwordField.leftViewActiveColor    = passwordCorrect ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        passwordField.dividerActiveColor     = passwordCorrect ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        passwordField.placeholderActiveColor = passwordCorrect ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)

        let msg = passwordCorrect ? "密码正确" : "密码错误"
        print(msg)
    }
    
    func checkConfirmPassword(){
        let isConfirmed = (passwordField.text == passwordConfirmField.text)        
        passwordConfirmField.leftViewActiveColor    = isConfirmed ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        passwordConfirmField.dividerActiveColor     = isConfirmed ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        passwordConfirmField.placeholderActiveColor = isConfirmed ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        okButton.isEnabled = passwordCorrect && isConfirmed
        okButton.backgroundColor = passwordCorrect && isConfirmed ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        let msg = passwordCorrect ? "密码正确" : "密码错误"
        print(msg)
    }
    
}
