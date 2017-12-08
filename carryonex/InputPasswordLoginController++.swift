//
//  InputPasswordLoginController++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/16.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

// TODO: what is the difference between this controller and RegisterPasswordController? Do we need both??? - Xin
extension InputPasswordLoginController: UITextFieldDelegate {
    
    func okButtonTapped(){
        
//        guard let username = username, let password = passwordField.text else {
//            displayAlert(title: "请输入密码", message: "密码不能为空", action: "知道了") {
//                _ = self.passwordField.becomeFirstResponder()
//            }
//            return
//        }
//        
//        _ = passwordField.resignFirstResponder()
//        
//        ProfileManager.shared.login(username: username, phone: phone, password: password) { (success) in
//            if success {
//                self.dismiss(animated: true, completion: nil)
//                
//            } else {
//                self.passwordField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
//                self.passwordField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
//                self.passwordField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
//                self.passwordField.detailLabel.textColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
//                self.passwordField.detailLabel.text = "密码错误请重新输入"
//            }
//        }
    }
    
    func forgetButtonTapped(){

        if let profileUser = ProfileManager.shared.getCurrentUser() {
            phoneInput = profileUser.phone ?? ""
            zoneCodeInput = profileUser.phoneCountryCode ?? ""
            
            print("get : okButtonTapped, api send text msg and go to next page!!!")
            SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneInput, zone: zoneCodeInput, result: { (err) in
                if err == nil {
                    print("PhoneNumViewController: 获取验证码成功, go next page!!!")
                    self.goToVerificationPage(isModifyPhone: true)
                } else {
                    print("PhoneNumViewController: 有错误: \(String(describing: err))")
                    let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(String(describing: err))"
                    self.showAlertWith(title: "验证失败", message: msg)
                }
            })
        }
    }
    
    func goToVerificationPage(isModifyPhone: Bool){
        let verifiCtl = VerificationController()
        verifiCtl.isModifyPhoneNumber = isModifyPhone
        verifiCtl.zoneCodeInput = self.zoneCodeInput
        verifiCtl.phoneInput = self.phoneInput
        
        self.navigationController?.pushViewController(verifiCtl, animated: true)
    }
    
    private func showAlertWith(title:String, message:String){
        let alertCtl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtl.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alertCtl.dismiss(animated: true, completion: nil)
        }))
        self.present(alertCtl, animated: true, completion: nil)
    }
    
    func checkPassword(){
        passwordField.leftViewNormalColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        passwordField.dividerNormalColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        passwordField.placeholderNormalColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        passwordField.detailLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        passwordField.detailLabel.text = "请输入6位以上密码"
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)
        let maybePassword = passwordField.text
        
        let isMatch = matcher.match(input: maybePassword!)
        passwordField.leftViewActiveColor    = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        passwordField.dividerActiveColor     = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        passwordField.placeholderActiveColor = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        okButton.isEnabled = isMatch
        okButton.backgroundColor = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        let msg = isMatch ? "密码正确" : "密码错误"
        print(msg)
    }
}
