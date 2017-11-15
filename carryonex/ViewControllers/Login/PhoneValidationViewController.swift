//
//  PhoneValidationViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class PhoneValidationViewController: UIViewController {

    var registerUserInfo : [String:String]? {
        didSet{
            zoneCodeInput = registerUserInfo?["countryCode"] ?? ""
            phoneInput = registerUserInfo?["phone"] ?? ""
            verifyCodeLabel01.text = ""
            verifyCodeLabel02.text = ""
            verifyCodeLabel03.text = ""
            verifyCodeLabel04.text = ""
            getVerificationCode()
        }
    }
    
    var isModifyPhoneNumber = false
    
    var zoneCodeInput: String = "1"
    var phoneInput: String = ""
    var verificationCode = "1234"
    
    var resetTime: Int = 0
    var resetTimer : Timer?
    
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var verifyCodeLabel01: UILabel!
    @IBOutlet weak var verifyCodeLabel02: UILabel!
    @IBOutlet weak var verifyCodeLabel03: UILabel!
    @IBOutlet weak var verifyCodeLabel04: UILabel!
    
    @IBOutlet weak var resendButton: UIButton!
    
    weak var phoneNumberCtrlDelegate : PhoneNumberDelegate?
    
    lazy var verifiTextField: UITextField = {
        let f = UITextField()
        f.delegate = self
        f.layer.borderWidth = 0
        f.keyboardType = .numberPad
        f.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return f
    }()

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifiTextField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupVerifyTextField()
    }
    
    
    private func setupVerifyTextField(){ // hide it under the screen
        view.addSubview(verifiTextField)
        verifiTextField.addConstraints(left: view.leftAnchor, top: view.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 30, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    
    @IBAction func resendButtonTapped(_ sender: UIButton) {
        print("should resend verification...")
        guard verificationCode.count == 4 else { return }
        commitVerificationCode()
        resetResendButtonTo60s()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    fileprivate func resetResendButtonTo60s(){
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
    
    
    fileprivate func getVerificationCode(){
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneInput, zone: zoneCodeInput, result: { (err) in
            if err == nil {
                print("PhoneNumViewController: 获取验证码成功!!")
            } else {
                print("PhoneNumViewController: mdfPhone有错误: \(String(describing: err))")
                let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(String(describing: err))"
                self.displayGlobalAlert(title: "获取验证码失败", message: msg, action: "OK", completion: nil)
            }
        })

    }

    fileprivate func commitVerificationCode(){
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
        if isModifyPhoneNumber {
            let newPhone = zoneCodeInput + "-" + phoneInput
            ApiServers.shared.postUpdateUserInfo(.phone, value: newPhone, completion: { (success, err) in
                if success, let currUser = ProfileManager.shared.getCurrentUser() {
                    currUser.phoneCountryCode = self.zoneCodeInput
                    currUser.phone = self.phoneInput
                    self.confirmPhoneInServer()
                } else if let err = err {
                    print("failed in VerificationController++, verifySuccess(), msg = ", err)
                    self.verifyFaildAlert(err.localizedDescription)
                }
            })
        } else {
            registerUser()
            //let regPswdCtl = RegisterPasswordController()
            //regPswdCtl.isRegister = true
            //regPswdCtl.zoneCodeInput = self.zoneCodeInput
            //regPswdCtl.phoneInput = self.phoneInput
            //self.navigationController?.pushViewController(regPswdCtl, animated: true)
        }
    }
    
    // TODO: do this after phone verified:
    private func registerUser(){
        guard let info = registerUserInfo else { return }
        
        ProfileManager.shared.register(username:    phoneInput,
                                       countryCode: zoneCodeInput,
                                       phone:       phoneInput,
                                       password:    info["password"] ?? "",
                                       name:        info["realName"] ?? "",
                                       completion: { (success, err, errType) in
                                        
                                        if success {
                                            self.confirmPhoneInServer()
                                            
                                        } else {
                                            let e1 = "您所使用的手机号已注册，请使用密码登陆即可。"
                                            let e2 = "注册出现错误，请确保所填信息正确，稍后再试一次。\n错误: \(err.debugDescription)"
                                            let msg = (errType == ErrorType.userAlreadyExist ? e1 : e2)
                                            self.displayGlobalAlert(title: "⚠️不能注册", message: msg, action: "好", completion: {
                                                if errType == .userAlreadyExist {
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                            })
                                        }
                                        
        })
        
    }
    

    private func confirmPhoneInServer(){
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension PhoneValidationViewController: UITextFieldDelegate {
    
    func textFieldDidChange(_ textField: UITextField){
        verificationCode = textField.text ?? ""
        let cnt = verificationCode.count
        if cnt == 0 {
            verifyCodeLabel01?.text = ""
            
        }else if cnt == 1 {
            verifyCodeLabel01?.text = String(describing: verificationCode.last!)
            verifyCodeLabel02?.text = ""
            verifyCodeLabel03?.text = ""
            verifyCodeLabel04?.text = ""
            
        }else if cnt == 2 {
            verifyCodeLabel02?.text = String(describing: verificationCode.last!)
            verifyCodeLabel03?.text = ""
            verifyCodeLabel04?.text = ""
            
        }else if cnt == 3 {
            verifyCodeLabel03?.text = String(describing: verificationCode.last!)
            verifyCodeLabel04?.text = ""
            
        }else if cnt == 4 {
            verifyCodeLabel04?.text = String(describing: verificationCode.last!)
            if resetTime == 0 {
                commitVerificationCode()
                resetResendButtonTo60s()
            }
            
        }else if cnt > 4 { // limit the size of input
            let idx = verificationCode.index(verificationCode.startIndex, offsetBy: 4)
            let newCode = verificationCode.substring(to: idx)
            textField.text = newCode
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.verifiTextField.becomeFirstResponder()
    }
    

}
