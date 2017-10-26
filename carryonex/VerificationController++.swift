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
        guard verificationCode.characters.count == 4 else { return }
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
        let cnt = verificationCode.characters.count
        if cnt == 0 {
            verifiCodeLabel1?.text = ""
        }else
        if cnt == 1 {
            verifiCodeLabel1?.text = String(describing: verificationCode.characters.last!)
            verifiCodeLabel2?.text = ""
            verifiCodeLabel3?.text = ""
            verifiCodeLabel4?.text = ""
        }else
        if cnt == 2 {
            verifiCodeLabel2?.text = String(describing: verificationCode.characters.last!)
            verifiCodeLabel3?.text = ""
            verifiCodeLabel4?.text = ""
        }else
        if cnt == 3 {
            verifiCodeLabel3?.text = String(describing: verificationCode.characters.last!)
            verifiCodeLabel4?.text = ""
        }else
        if cnt == 4 {
            verifiCodeLabel4?.text = String(describing: verificationCode.characters.last!)
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
        //let zoneCode = ProfileManager.shared.currentUser?.phoneCountryCode
        //let phoneNum = ProfileManager.shared.currentUser?.phone!
        let registEmailCtl = RegisterEmailController()
        //print("get 4 code: will commitVerificationCode: \(verificationCode), and my phone: \(phoneNum), zoneCode: \(zoneCode)")
//            guard zoneCode != "", phoneNum != "", zoneCode != "0", phoneNum != "0" else { return }
//            SMSSDK.commitVerificationCode(verificationCode, phoneNumber: phoneNum, zone: zoneCode, result: { (err) in
//                print(zoneCode,phoneNum)
//                if err == nil {
                    self.navigationController?.pushViewController(registEmailCtl, animated: true)
//                } else {
//                    self.verifyFaild(err)
//                }
//            })
//        }
    }
    
//    private func verifySuccess(){
//        DispatchQueue.main.async {
//            ProfileManager.shared.saveUser()
//            if let newPhone = ProfileManager.shared.currentUser?.phone {
//                ApiServers.shared.postUpdateUserInfo(.phone, newInfo: newPhone, completion: { (success, msg) in
//                    print("postUpdateUserInfo phone isSuccess = \(success), msg = \(msg)")
//                })
//            }
//        }

    func dismissAndBackToHomePage(){
        dismiss(animated: false) {
            self.phoneNumberCtrlDelegate?.dismissAndReturnToHomePage()
        }
    }
//    private func verifyFaild(_ err: Error?){
//        print("验证失败，error: \(err!)")
//        let errMsg = "抱歉验证遇到问题，是不是验证码没填对？或请稍后重新发送新的验证码。错误原因: \(err!)"
//        showAlertWith(title: "验证失败", message: errMsg)
//    }
//
//    func goNextPage(){ // development page jump use
//        verifySuccess()
//    }
    
    private func showAlertWith(title:String, message:String){
        let alertCtl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtl.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alertCtl.dismiss(animated: true, completion: nil)
        }))
        self.present(alertCtl, animated: true, completion: nil)
    }
    
}

