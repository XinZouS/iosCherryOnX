//
//  VerificationViewController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension VerificationController: UITextFieldDelegate {
    
    
    
    func resendButtonTapped(){
        print("should resend verification...")
        guard verificationCode.count == 4 else { return }
        commitVerificationCode()
        resetResendButtonTo60s()
    }
    
    private func resetResendButtonTo60s(){
        resetTime = 60
        resetTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown1sec), userInfo: nil, repeats: resetTime != 0)
    }
    func countDown1sec(){
        resendButton.backgroundColor = resetTime == 0 ? buttonThemeColor : UIColor.lightGray
        resendButton.isEnabled = (resetTime == 0)
        if resetTime == 0 {
            resetTimer?.invalidate()
            resendButton.setTitle("发送验证码", for: .normal)
        }else{
            resetTime -= 1
            resendButton.setTitle("\(resetTime)秒后重新发送", for: .normal)
        }
    }
    
    
    func textFieldDidChange(_ textField: UITextField){
        verificationCode = textField.text ?? ""
        let cnt = verificationCode.count
        if cnt == 0 {
            verifiCodeLabel1?.text = ""
        }else
        if cnt == 1 {
            verifiCodeLabel1?.text = String(describing: verificationCode.last!)
            verifiCodeLabel2?.text = ""
            verifiCodeLabel3?.text = ""
            verifiCodeLabel4?.text = ""
        }else
        if cnt == 2 {
            verifiCodeLabel2?.text = String(describing: verificationCode.last!)
            verifiCodeLabel3?.text = ""
            verifiCodeLabel4?.text = ""
        }else
        if cnt == 3 {
            verifiCodeLabel3?.text = String(describing: verificationCode.last!)
            verifiCodeLabel4?.text = ""
        }else
        if cnt == 4 {
            verifiCodeLabel4?.text = String(describing: verificationCode.last!)
            if resetTime == 0 {
                commitVerificationCode()
                resetResendButtonTo60s()
            }
        }else
        if cnt > 4 { // limit the size of input
            let idx = verificationCode.index(verificationCode.startIndex, offsetBy: 4)
            let newCode = verificationCode.substring(to: idx)
            textField.text = newCode
        }
        
    }
    
    // MARK: textField delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.verifiTextField.becomeFirstResponder()
    }
    
    
    // setup limit of textField input size
    
    private func commitVerificationCode(){
        if isModifyPhoneNumber, let profileUser = ProfileManager.shared.getCurrentUser() {
            zoneCodeInput = profileUser.phoneCountryCode ?? ""
            phoneInput = profileUser.phone ?? ""
        }
        
        guard zoneCodeInput != "", phoneInput != "", zoneCodeInput != "0", phoneInput != "0" else { return }
        
        SMSSDK.commitVerificationCode(verificationCode, phoneNumber: phoneInput, zone: zoneCodeInput, result: { (err) in
            if err == nil {
                self.verifySuccess()
            } else {
                self.verifyFaildAlert(err?.localizedDescription)
            }
        })
    }

    private func verifySuccess(){
        if isRegister {
            let registEmailCtl = RegisterEmailController()
            self.navigationController?.pushViewController(registEmailCtl, animated: true)
        } else {
            if isModifyPhoneNumber {
                let newPhone = zoneCodeInput + "-" + phoneInput
                ApiServers.shared.postUpdateUserInfo(.phone, value: newPhone, completion: { (success, err) in
                    if success, let currUser = ProfileManager.shared.getCurrentUser() {
                        currUser.phoneCountryCode = zoneCodeInput
                        currUser.phone = phoneInput
                        self.confirmInServer()
                    } else if let err = err {
                        print("failed in VerificationController++, verifySuccess(), msg = ", err)
                        self.verifyFaildAlert(err.localizedDescription)
                    }
                })
            } else {
                let regPswdCtl = RegisterPasswordController()
                regPswdCtl.isRegister = true
                self.navigationController?.pushViewController(regPswdCtl, animated: true)
            }
        }
    }
    
    private func confirmInServer(){
        ApiServers.shared.postUpdateUserInfo(.isPhoneVerified, value: "1") { (success, err) in
            if let err = err {
                print("get error when .postUpdateUserInfo(.isPhoneVerified: err = \(err.localizedDescription)")
                self.verifyFaildAlert(err.localizedDescription)
                return
            }
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func verifyFaildAlert(_ msg: String?){
        let errMsg = "抱歉验证遇到问题，是不是验证码没填对？或请稍后重新发送新的验证码。错误原因:" + (msg ?? "验证失败")
        print("VerificationController++: verifyFaild(): 验证失败，error: \(errMsg)")
        
        displayGlobalAlert(title: "验证失败", message: errMsg, action: "重发验证码", completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
}

