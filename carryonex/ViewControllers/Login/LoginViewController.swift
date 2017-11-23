//
//  LoginViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    fileprivate let constant: CGFloat = 32
    var countryCode = "1"
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var textFieldsContainerView: UIView!
    
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var wechatLoginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhoneTextField()
        setupPasswordTextField()
    }
    
    
    //MARK: - View custom set up
    
    private func setupPhoneTextField(){
        phoneField.keyboardType = .numberPad
        phoneField.delegate = self
    }

    private func setupPasswordTextField(){
        passwordField.keyboardType = .asciiCapable
        passwordField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        passwordField.delegate = self
        
        /*
        passwordField = TextField()
        passwordField.placeholder = "密码"
        passwordField.detail = "请输入6位以上密码"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.keyboardAppearance = .dark
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        _ = passwordField.becomeFirstResponder()
        passwordField.placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        view.layout(passwordField).center(offsetY: -100).left(60).right(60)
         */
    }
    
    //MARK: - Action Handler
    
    @IBAction func handleLoginButton(sender: UIButton) {
        guard let phone = phoneField.text else {
            displayAlert(title: L("login.error.title.phone"),
                         message: L("login.error.message.phone"),
                         action: L("action.ok")) {
                _ = self.phoneField.becomeFirstResponder()
            }
            AudioManager.shared.playSond(named: .failed)
            return
        }
        
        guard let password = passwordField.text else {
            displayAlert(title: L("login.error.title.password"),
                         message: L("login.error.message.password"),
                         action: L("action.ok")) {
                _ = self.passwordField.becomeFirstResponder()
            }
            AudioManager.shared.playSond(named: .failed)
            return
        }
        
        _ = passwordField.resignFirstResponder()
        
        ProfileManager.shared.login(username: phone, password: password) { (success) in
            
            if success {
                self.dismiss(animated: true, completion: nil)

            } else {
                AudioManager.shared.playSond(named: .failed)
            }
        }
    }
    
    @IBAction func handleForgetButton(sender: UIButton) {
        if let profileUser = ProfileManager.shared.getCurrentUser() {
            if let phone = profileUser.phone {
                let countryCode = profileUser.phoneCountryCode ?? "1"
                print("get : okButtonTapped, api send text msg and go to next page!!!")
                SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phone, zone: countryCode, result: { (err) in
                    if err == nil {
                        print("PhoneNumberController: 获取验证码成功, go next page!!!")
                        self.goToVerificationPage(isModifyPhone: true)
                    } else {
                        print("PhoneNumberController: 有错误: \(String(describing: err))")
                        let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(String(describing: err))"
                        self.displayAlert(title: "验证失败", message: msg, action: "好")
                    }
                })
            }
        }
    }
    
    func goToVerificationPage(isModifyPhone: Bool) {
        if let phone = phoneField.text {
            let verifiCtl = VerificationController()
            verifiCtl.isModifyPhoneNumber = isModifyPhone
            verifiCtl.zoneCodeInput = self.countryCode
            verifiCtl.phoneInput = phone
            self.navigationController?.pushViewController(verifiCtl, animated: true)
        }
    }
    
    //MARK - Helper Method
    
    @IBAction func wechatButtonTapped(_ sender: Any) {
        wxloginStatus = "WXregister"
        let urlStr = "weixin://"
        if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
            let red = SendAuthReq.init()
            red.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
            red.state = "\(arc4random()%100)"
            WXApi.send(red)
        }else{
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
            }
        }
    }
    
    func makeUserRegister(openid:String,access_token:String){
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openid)"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                print(jsonResult)
                if let username = jsonResult["openid"] as? String,let imgUrl = jsonResult["headimgurl"] as? String,let realName = jsonResult["nickname"] as? String{
                    // check wechat account existed?
                    ApiServers.shared.getIsUserExisted(phoneInput: username,completion: { (success, err) in
                        if success{
                            // if exist log in
                            ProfileManager.shared.login(username: username, password: username,completion: { (success) in
                                if success{
                                    // if log in success update image
                                    ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (success) in
                                        if success {
                                            //if update success close
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    })
                                }else{
                                    print("errorelse")
                                }
                            })
                        }else{
                            //if doesn't exist then register
                            ProfileManager.shared.register(username: username, countryCode: "86", phone: "no_phone", password:username,email: "",name: realName,completion: { (success, err, errType) in
                                if success{
                                    //if register success update image
                                    ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (success) in
                                        if success {
                                            //if update success close
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    })
                                }else{
                                    print(errType)
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    func checkPassword(){
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)
        let maybePassword = passwordField.text
        
        let isMatch = matcher.match(input: maybePassword!)

        
        loginButton.isEnabled = isMatch
        loginButton.backgroundColor = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        let msg = isMatch ? "密码正确" : "密码错误"
        print(msg)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissKeyboard()
    }
    
    private func dismissKeyboard(){
        phoneField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}
