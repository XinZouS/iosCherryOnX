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
        let regPwCtl = RegisterPasswordController()
        regPwCtl.zoneCodeInput = self.zoneCodeInput
        regPwCtl.phoneInput = self.phoneInput
        regPwCtl.emailInput = self.emailField.text ?? ""
        navigationController?.pushViewController(regPwCtl, animated: true)
    }
    
    func checkEmail(){
        let emailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = MyRegex(emailPattern)
        let maybeEmail = emailField.text
        
        let isMatch = matcher.match(input: maybeEmail!)
        emailField.leftViewActiveColor      = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        emailField.dividerActiveColor       = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        emailField.placeholderActiveColor   = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        okButton.isEnabled = true
        okButton.backgroundColor            = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        let msg = isMatch ? "Email正确" : "Email错误"
        print(msg)
    }

}
