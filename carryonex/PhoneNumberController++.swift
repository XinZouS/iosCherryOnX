//
//  PhoneNumberController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

protocol PhoneNumberDelegate : class {
    func dismissAndReturnToHomePage()
}

extension PhoneNumberController: UITextFieldDelegate, PhoneNumberDelegate {
    
    func nextButtonTapped() {
        guard let newPhone = phoneNumberTextField.text else {
            let m = "您还没填写电话号码呢！"
            displayGlobalAlert(title: "❓缺少信息", message: m, action: "朕知道了", completion: nil)
            return
        }
        
        isLoading = true        
        ApiServers.shared.getIsUserExisted(phoneInput: newPhone) { (isExist, error) in
            self.isLoading = false
            
            if let error = error {
                print("getIsUserExisted error: \(error.localizedDescription)")
                return
            }
            if isExist {
                if self.isModifyPhoneNumber {
                    self.modifyUserPhoneNum(newPhone)
                } else {
                    self.loginByPasswordInput()
                }
            } else {
                self.verifyUserPhoneNum()
            }
        }
    }
    
    private func modifyUserPhoneNum(_ newPhone: String){
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("nextButtonTapped error: Profile has no current user")
            return
        }
        let phoneNum = profileUser.phone ?? ""
        let zoneNum = profileUser.phoneCountryCode ?? ""
        
        self.isLoading = true
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneNum, zone: zoneNum, result: { (err) in
            self.isLoading = false
            if err == nil {
                print("PhoneNumberController: 获取验证码成功, go next page!!!")
                self.goToVerificationPageWith(zoneCode: zoneNum, phoneNum: phoneNum)
            } else {
                print("PhoneNumberController: mdfPhone有错误: \(String(describing: err))")
                let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(String(describing: err))"
                self.showAlertWith(title: "获取验证码失败", message: msg)
            }
        })
    }
    
    private func loginByPasswordInput(){
        let pwVC = InputPasswordLoginController()
        pwVC.username = phoneInput
        self.navigationController?.pushViewController(pwVC, animated: true)
    }
    
    private func verifyUserPhoneNum(){
        self.isLoading = true
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneInput, zone: zoneCodeInput, result: { (err) in
            self.isLoading = false
            if let err = err {
                print("PhoneNumberController: lgoin有错误: \(String(describing: err))")
                let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(String(describing: err))"
                self.showAlertWith(title: "验证失败", message: msg)
                return
            }
            self.goToVerificationPageWith(zoneCode: zoneCodeInput, phoneNum: phoneInput)
        })

    }
    
    @objc private func nextButtonEnable(){
        nextButton.isEnabled = false
        nextButton.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
    private func showAlertWith(title:String, message:String){
        let alertCtl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtl.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alertCtl.dismiss(animated: true, completion: nil)
        }))
        self.present(alertCtl, animated: true, completion: nil)
    }
    
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        phoneNumberTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if touches.count > 0 {
            textFieldsInAllCellResignFirstResponder()
        }
    }
    
    func showUserAgreementPage(){
        let disCtrlView = DisclaimerController()
        self.navigationController?.pushViewController(disCtrlView, animated: true)
    }
    
    func goToVerificationPageWith(zoneCode: String, phoneNum: String){
        let verifiCtl = VerificationController()
        verifiCtl.isRegister = true
        self.navigationController?.pushViewController(verifiCtl, animated: true)
    }

    
    
    // MARK: textField and keyboard
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _ = phoneNumberTextField.becomeFirstResponder()
        flagPicker.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        phoneNumberTextField.resignFirstResponder()
    }
    
    func checkPhone(){
        var phonePattern = ""
        switch zoneCodeInput {
        case "86":
            phonePattern = "^1[0-9]{10}$"
        case "1":
            phonePattern = "^[0-9]{10}$"
        default:
            phonePattern = "^[0-9]{10}$"
        }
        let matcher = MyRegex(phonePattern)
        phoneInput = phoneNumberTextField.text ?? ""
        
        let isFormatOK = matcher.match(input: phoneInput)
        let isUserAgree = agreeCheckbox.checkState == .checked
        
        phoneNumberTextField.leftViewActiveColor    = isFormatOK ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        phoneNumberTextField.dividerActiveColor     = isFormatOK ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        phoneNumberTextField.placeholderActiveColor = isFormatOK ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        isPhoneNumValid = isFormatOK
        nextButton.isEnabled = isFormatOK && isUserAgree
        nextButton.backgroundColor = nextButton.isEnabled ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        let msg = isFormatOK ? "电话格式正确" : "电话格式有误"
        print(msg)
    }
    
    func agreeCheckboxChanged(){
        if isPhoneNumValid {
            updateNextButton()
        }
    }
    
    private func updateNextButton(){
        guard let num = phoneNumberTextField.text else { return }
        isPhoneNumValid = (num.count >= 6)
        let isUserAgree = agreeCheckbox.checkState == .checked
        if isPhoneNumValid {
            nextButton.isEnabled = isUserAgree && isPhoneNumValid
            nextButton.backgroundColor = nextButton.isEnabled ? buttonThemeColor : .lightGray
        }
    }
    
    func setupKeyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func keyboardDidShow(){
        flagPicker.isHidden = true
    }
    
    func keyboardDidHide(){
    
    }
    
    
    // MARK: pickerView delegate
    
    func openFlagPicker(){
        flagPicker.isHidden = !flagPicker.isHidden
        // will hide when begin to set phoneNum
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return flagsTitle.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return flagsTitle[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        zoneCodeInput = codeOfFlag[flagsTitle[row]]!
        flagButton.setTitle(flagsTitle[row], for: .normal)
        checkPhone()
    }
    
    
    // MARK: delegate: go back to home page
    
    func dismissAndReturnToHomePage(){
        self.navigationController?.popToRootViewController(animated: false)
        self.dismiss(animated: true) {
            print("go back to home page.")
        }
    }
    
    func cancelButtonTapped(){
        if self.navigationController?.viewControllers.count == 1 {
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
