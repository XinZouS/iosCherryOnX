//
//  RegistrationViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var bottomImageView: UIImageView!
    
    var registerUserInfo : [String:String]?
    
    var isPasswordValid = false {
        didSet{
            checkRegistrationButtonReady()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        nameField.keyboardType = .default
        passwordField.keyboardType = .default
        confirmPasswordField.keyboardType = .default
        
        nameField.addTarget(self, action: #selector(checkRegistrationButtonReady), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(isPasswordValidate), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(isPasswordValidate), for: .editingChanged)
        
        bottomImageView.image = UIImage.gifImageWithName("Login_animated_loop_png")
        
        AnalyticsManager.shared.startTimeTrackingKey(.registrationProcessTime)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsManager.shared.clearTimeTrackingKey(.registrationProcessTime)
    }
    
    
    //MARK: Action Handler
    
    @IBAction func handleRegisterButton(sender: UIButton) {
        
        guard let userName = nameField.text else {
            AudioManager.shared.playSond(named: .failed)
            return
        }
        
        guard isPasswordValid else {
            AudioManager.shared.playSond(named: .failed)
            return 
        }
        
        guard let password = passwordField.text else { 
            AudioManager.shared.playSond(named: .failed)
            return 
        }
        
        guard let phone = registerUserInfo?["phone"], let countryCode = registerUserInfo?["countryCode"] else {
            AudioManager.shared.playSond(named: .failed)
            return
        }
        registerUser(name: userName, password: password, phone: phone, countryCode: countryCode)
    }
    
    
    //MARK: Helper
    
    private func registerUser(name: String, password: String, phone: String, countryCode: String){
        ProfileManager.shared.register(username: phone,
                                       countryCode: countryCode,
                                       phone: phone,
                                       password: password,
                                       name: name,
                                       completion: { (success, err, errType) in
                                        
                                        if success {
                                            print("注册成功...")
                                            ProfileManager.shared.login(username: phone, password: password, completion: { (success) in
                                                if success {
                                                    print("注册后登入成功...")
                                                    ProfileManager.shared.updateUserInfo(.isPhoneVerified, value: 1) { (success) in
                                                        if success {
                                                            self.dismiss(animated: true, completion: nil)
                                                            AnalyticsManager.shared.finishTimeTrackingKey(.registrationProcessTime)
                                                        } else {
                                                            self.displayGlobalAlert(title: L("register.error.title.verify"),
                                                                                    message: L("register.error.message.verify-phone"),
                                                                                    action: L("register.error.action.verify"), completion: nil)
                                                        }
                                                    }
                                                } else {
                                                    print("登入失败")
                                                    self.displayGlobalAlert(title: "登入失败",
                                                                            message: "注册成功但登入失败，请检查你的网络。",
                                                                            action: L("action.ok"), completion: nil)
                                                }
                                            })
                                        } else {
                                            print("注册失败")
                                            self.displayGlobalAlert(title: L("register.error.title.failed"), message: L("register.error.message.failed") + ": \(err?.localizedDescription ?? L("register.error.title.failed"))", action: L("action.ok"), completion: { [weak self] _ in
                                                self?.navigationController?.popToRootViewController(animated: true)
                                            })
                                        }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PhoneValidationViewController {
            if let info = sender as? [String:String] {
                destVC.registerUserInfo = info
            }
        } else {
            print("get error: RegistrationVC: prepare for segue get nil at destVC...")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboards()
    }
    
    fileprivate func dismissKeyboards(){
        nameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()
    }
    
    private func isPasswordPatternValidate(textField: UITextField) -> Bool {
        guard let pw = textField.text, pw != "" else { return false }
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)

        return matcher.match(input: pw)
    }
    
    func isPasswordValidate() -> Bool {
        guard let password = passwordField.text, let confirm = confirmPasswordField.text, password != "", confirm != "" else {
            isPasswordValid = false
            checkRegistrationButtonReady()
            return false
        }
        checkRegistrationButtonReady()
        isPasswordValid = isPasswordPatternValidate(textField: passwordField) && password == confirm
        
        return isPasswordValid
    }
    
    func checkRegistrationButtonReady() {
        let nameOk = (nameField.text != nil && nameField.text != "")
        let ok = isPasswordValid && nameOk
        registerButton.isEnabled = ok
        registerButton.backgroundColor = ok ? colorOkgreen : colorErrGray
        registerButton.setTitleColor(.white, for: .normal)
    }
    
    
    @IBAction func agreeButtonTapped(_ sender: Any) {
        gotoWebview(title: L("login.ui.agreement.title"), url: "\(ApiServers.shared.host)/doc_agreement")
    }
    
    private func gotoWebview(title: String, url: String) {
        let webVC = WebController()
        self.navigationController?.pushViewController(webVC, animated: true)
        webVC.title = title
        webVC.url = URL(string: url)
    }

}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboards()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismissKeyboards()
        return true
    }
    
}
