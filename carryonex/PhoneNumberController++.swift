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
    
    // MARK: logic func
    
//    func okButtonTapped(){
//        okButtonDisable()
//        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(okButtonEnable), userInfo: nil, repeats: false)
//
//        let phoneNum = User.shared.phone ?? "0"
//        let zoneCode = User.shared.phoneCountryCode ?? "86"
//        print("get : okButtonTapped, api send text msg and go to next page!!!")
//        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneNum, zone: zoneCode, result: { (err) in
//            print(err)
//            if err == nil {
//                print("PhoneNumberController: 获取验证码成功, go next page!!!")
//                self.goToVerificationPage()
//            } else {
//                print("PhoneNumberController: 有错误: \(err)")
//                let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(err)"
//                self .showAlertWith(title: "获取验证码失败", message: msg)
//            }
//        })
//    }
//    private func okButtonDisable(){
//        okButton.setTitle("正在请求验证码...", for: .normal)
//        okButton.backgroundColor = .lightGray
//        okButton.isEnabled = false
//    }
//    @objc private func okButtonEnable(){
//        okButton.setTitle("获取验证码", for: .normal)
//        okButton.backgroundColor = buttonThemeColor
//        okButton.isEnabled = true
//    }
    func nextButtonTapped(){
         _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(nextButtonEnable), userInfo: nil, repeats: false)
        var alreadyExist = false
        if alreadyExist == true{
            let phoneNum = User.shared.phone ?? "0"
            let zoneCode = User.shared.phoneCountryCode ?? "86"
            print("get : okButtonTapped, api send text msg and go to next page!!!")
            SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneNum, zone: zoneCode, result: { (err) in
                print(err)
                if err == nil {
                    print("PhoneNumberController: 获取验证码成功, go next page!!!")
                    self.goToVerificationPage()
                } else {
                    print("PhoneNumberController: 有错误: \(err)")
                    let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(err)"
                    self .showAlertWith(title: "获取验证码失败", message: msg)
                }
            })
        }else{
            let verifiCtl = VerificationController()
            verifiCtl.isRegister = 1
            navigationController?.pushViewController(verifiCtl, animated: true)
        }
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
        
        guard let touch = touches.first else { return }
        
        textFieldsInAllCellResignFirstResponder()
        
    }
    
    func showUserAgreementPage(){
        let disCtrlView = DisclaimerController()
        self.navigationController?.pushViewController(disCtrlView, animated: true)
    }
    
    // development use: go next page without phone verification
    func goToVerificationPage(){
        let verifiCtl = VerificationController()
        self.navigationController?.pushViewController(verifiCtl, animated: true)
    }

    
    
    // MARK: textField and keyboard
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneNumberTextField.becomeFirstResponder()
        flagPicker.isHidden = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        phoneNumberTextField.resignFirstResponder()
//        updatePhoneNum()
//        updateOkButton()
    }
    
    func checkPhone(){
        var phonePattern = ""
        switch User.shared.phoneCountryCode {
        case "86"?:
            phonePattern = "^1[0-9]{10}$"
        case "1"?:
            phonePattern = "^[0-9]{10}$"
        default:
            break
        }
        let matcher = MyRegex(phonePattern)
        let maybephone = phoneNumberTextField.text
        User.shared.phone = phoneNumberTextField.text
        if matcher.match(input: maybephone!) {
            print("电话格式正确")
            phoneNumberTextField.leftViewActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            phoneNumberTextField.dividerActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            phoneNumberTextField.placeholderActiveColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            isPhoneNumValid = true
        }
        else{
            phoneNumberTextField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            phoneNumberTextField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            phoneNumberTextField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            print("电话格式有误")
            isPhoneNumValid = false
        }
    }
    
    func agreeCheckboxChanged(){
        print("TODO: agreeCheckboxChanged() !!!!!")
        updateNextButton()
//        updateRegistButton()
    }
    
    private func updatePhoneNum(){
        let phoneNumber = phoneNumberTextField.text ?? "0"
        User.shared.phone = phoneNumber
    }
//
    private func updateNextButton(){
        guard let num = phoneNumberTextField.text else { return }
        isPhoneNumValid = (num.characters.count >= 6)
        isUserAgree = agreeCheckbox.checkState == .checked
        if isPhoneNumValid == true{
            nextButton.isEnabled = isUserAgree && isPhoneNumValid
            nextButton.backgroundColor = nextButton.isEnabled ? buttonThemeColor : .lightGray
        }
    }
    
    //WECHAT lOGIN
    func wechatButtonTapped(){
        let urlStr = "weixin://"
//        if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
            let red = SendAuthReq.init()
            red.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
            red.state = "\(arc4random()%100)"
            WXApi.send(red)
//        }else{
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
//            } else {
//                // Fallback on earlier versions
//                UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
//            }
//        }
    }
    /**  微信通知  */
    func WXLoginSuccess(notification:Notification) {
        
        let code = notification.object as! String
        let requestUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(WX_APPID)&secret=\(WX_APPSecret)&code=\(code)&grant_type=authorization_code"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                let openid: String = jsonResult["openid"] as! String
                let access_token: String = jsonResult["access_token"] as! String
                self.getUserInfo(openid: openid, access_token: access_token)
            }
        }
    }
    
    /**  获取用户信息  */
    func getUserInfo(openid:String,access_token:String) {
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openid)"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                print(jsonResult)
                
            }
        }
    }
    
//    func registerButtonTapped(){
//        let verifiCtl = VerificationController()
//        verifiCtl.isRegister = 1
//        navigationController?.pushViewController(verifiCtl, animated: true)
//    }
    
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
        User.shared.phoneCountryCode = codeOfFlag[flagsTitle[row]]!
        flagButton.setTitle(flagsTitle[row], for: .normal)
        print("pick countryCode: " , User.shared.phoneCountryCode)
    }
    
    
    // MARK: delegate: go back to home page
    
    func dismissAndReturnToHomePage(){
        self.navigationController?.popToRootViewController(animated: false)
        self.dismiss(animated: true) {
            print("go back to home page.")
        }
    }
    

    
}

