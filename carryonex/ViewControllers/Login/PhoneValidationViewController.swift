//
//  PhoneValidationViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class PhoneValidationViewController: UIViewController {

    var isModifyPhoneNumber = false
    var status: LoginStatus = .registeration
    var zoneCodeInput: String = "1"
    var phoneInput: String = ""
    var verificationCode = "1234"
    
    var resetTime: Int = 0
    var resetTimer : Timer?
    
    let segueIdRegistrationVC = "gotoRegistrationVC"
    let segueIdChangePw = "gotoChangePassword"
    
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

    var registerUserInfo : [String:String]?
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        zoneCodeInput = registerUserInfo?["countryCode"] ?? ""
        phoneInput = registerUserInfo?["phone"] ?? ""
        print(zoneCodeInput)
        print(phoneInput)
        verifyCodeLabel01.text = ""
        verifyCodeLabel02.text = ""
        verifyCodeLabel03.text = ""
        verifyCodeLabel04.text = ""
        setupUserPhoneShow()
        verifiTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verifiTextField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVerifyTextField()
    }
    
    private func setupUserPhoneShow(){
        hintLabel.text = L("register.ui.message.hint1") + zoneCodeInput + " " + phoneInput + L("register.ui.message.hint2")
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
        
    fileprivate func resetResendButtonTo60s(){
        resetTime = 60
        resetTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown1sec), userInfo: nil, repeats: resetTime != 0)
    }
    func countDown1sec(){
        resendButton.backgroundColor = resetTime == 0 ? buttonThemeColor : UIColor.lightGray
        resendButton.isEnabled = (resetTime == 0)
        if resetTime == 0 {
            resetTimer?.invalidate()
            resendButton.setTitle(L("register.ui.message.resend-verify-code"), for: .normal)
        }else{
            resetTime -= 1
            resendButton.setTitle("\(resetTime)" + L("register.ui.message.resend-time"), for: .normal)
        }
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
                self.verifyFaildAlert(err)
            }
        })
    }
    
    
    @IBAction func inputButtonTapped(_ sender: Any) {
        verifiTextField.becomeFirstResponder()
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
                    debugPrint("failed in VerificationController++, verifySuccess(), msg = ", err)
                    self.verifyFaildAlert(err)
                }
            })
        } else {
            switch status {
            case .registeration :
                self.performSegue(withIdentifier: segueIdRegistrationVC, sender: registerUserInfo)
            case .changePassword :
                self.performSegue(withIdentifier: segueIdChangePw, sender: registerUserInfo)
            default:
//                self.performSegue(withIdentifier: "", sender: self)
//              useForChangePhoneNumber.
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdRegistrationVC {
            if let regVC = segue.destination as? RegistrationViewController,
                let info = sender as? [String:String] {
                regVC.registerUserInfo = info
            }
        }
        if segue.identifier == segueIdChangePw {
            if let regVC = segue.destination as? ChangePasswordController,
                let info = sender as? [String:String] {
                regVC.registerUserInfo = info
            }
        }
    }
    
    
    private func confirmPhoneInServer(){
        ApiServers.shared.postUpdateUserInfo(.isPhoneVerified, value: "1") { (success, error) in
            if let error = error {
                debugPrint("get error when .postUpdateUserInfo(.isPhoneVerified: err = \(error.localizedDescription)")
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                AudioManager.shared.playSond(named: .failed)
                self.verifyFaildAlert(error)
                return
            }
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func verifyFaildAlert(_ error: Error?){
        if let error = error {
            debugPrint("VerificationController++: verifyFaild(): 验证失败，error: \(error.localizedDescription)")
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            AudioManager.shared.playSond(named: .failed)
            displayGlobalAlert(title: L("register.error.title.verify"), message: L("register.error.message.verify") + " \(error.localizedDescription)", action: L("register.error.action.verify"), completion: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        }
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
