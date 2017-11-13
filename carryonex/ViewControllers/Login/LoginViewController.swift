//
//  LoginViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController {

    fileprivate let constant: CGFloat = 32
    var countryCode = "1"
    
    @IBOutlet weak var phoneField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var textFieldsContainerView: UIView!
    
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var wechatLoginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPasswordTextField()
        setupTextFieldContainerView()
    }
    
    
    //MARK: - View custom set up
    
    private func setupPasswordTextField(){
        passwordField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        let leftView = UIImageView()
        leftView.image = Icon.settings
        passwordField.leftView = leftView
        
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

    private func setupTextFieldContainerView(){
        let x = textFieldsContainerView.bounds.width
        let y = textFieldsContainerView.bounds.height / 2
        let cl = UIColor(white: 0.9, alpha: 1)
        let startP = CGPoint(x: 0, y: y)
        let endP = CGPoint(x: x, y: y)
        textFieldsContainerView.drawStroke(startPoint: startP, endPoint: endP, color: cl, lineWidth: 1)
    }

    
    //MARK: - Action Handler
    
    @IBAction func handleLoginButton(sender: UIButton) {
        guard let phone = phoneField.text else {
            displayAlert(title: L("login.error.title.phone"),
                         message: L("login.error.message.phone"),
                         action: L("action.ok")) {
                _ = self.phoneField.becomeFirstResponder()
            }
            return
        }
        
        guard let password = passwordField.text else {
            displayAlert(title: L("login.error.title.password"),
                         message: L("login.error.message.password"),
                         action: L("action.ok")) {
                _ = self.passwordField.becomeFirstResponder()
            }
            return
        }
        
        _ = passwordField.resignFirstResponder()
        
        ProfileManager.shared.login(username: phone, password: password) { (success) in
            
            if success {
                self.dismiss(animated: true, completion: nil)
                
            } else {
                self.passwordField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
                self.passwordField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
                self.passwordField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
                self.passwordField.detailLabel.textColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
                self.passwordField.detailLabel.text = L("login.error.message.wrong-password")
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
        
        loginButton.isEnabled = isMatch
        loginButton.backgroundColor = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        let msg = isMatch ? "密码正确" : "密码错误"
        print(msg)
    }
}
