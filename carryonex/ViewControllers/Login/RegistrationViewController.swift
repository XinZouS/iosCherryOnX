//
//  RegistrationViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Material

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var registerButton: Button!
    @IBOutlet weak var agreeButton: UIButton!
    
    var registerUserInfo : [String:String]?
    
    var isPasswordValid = false {
        didSet{
            checkRegistrationButtonReady()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextFields()
    }

    
    private func setupTextFields() {
        nameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        nameField.keyboardType = .default
        passwordField.keyboardType = .default
        confirmPasswordField.keyboardType = .default
        
        nameField.addTarget(self, action: #selector(checkRegistrationButtonReady), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(isPasswordValidate), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(isPasswordValidate), for: .editingChanged)
    }

    
    
    @IBAction func handleRegisterButton(sender: UIButton) {
        
        guard let userName = nameField.text else {
            AudioManager.shared.playSond(named: .failed)
            return
        }
//        if !isPasswordValidate() {
//            AudioManager.shared.playSond(named: .failed)
//            return
//        }
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
    
    private func registerUser(name: String, password: String, phone: String, countryCode: String){
        ProfileManager.shared.register(username: phone,
                                       countryCode: countryCode,
                                       phone: phone,
                                       password: password,
                                       name: name,
                                       completion: { (success, err, errType) in
                                        if success {
                                            ProfileManager.shared.updateUserInfo(.isPhoneVerified, value: 1) { (success) in
                                                if success {
                                                    ProfileManager.shared.login(username: phone, password: password, completion: { (success) in
                                                        self.dismiss(animated: true, completion: nil)
                                                    })
                                                } else {
                                                    self.displayGlobalAlert(title: "验证失败", message: "手机验证失败", action: "重发验证码", completion: { [weak self] _ in
                                                        self?.navigationController?.popToRootViewController(animated: true)
                                                    })
                                                }
                                            }
                                        } else {
                                            self.displayGlobalAlert(title: "注册失败", message: (err?.localizedDescription ?? "不能注册"), action: "好", completion: { [weak self] _ in
                                                self?.navigationController?.popToRootViewController(animated: true)
                                            })
                                        }
//                                        else {
//                                            let e1 = "您所使用的手机号已注册，请使用密码登陆即可。"
//                                            let e2 = "注册出现错误，请确保所填信息正确，稍后再试一次。\n错误: \(err.debugDescription)"
//                                            let msg = (errType == ErrorType.userAlreadyExist ? e1 : e2)
//
//                                        }
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
        registerButton.titleColor = .white
    }
    
    
    @IBAction func agreeButtonTapped(_ sender: Any) {
        let disCtrlView = DisclaimerController()
        self.navigationController?.pushViewController(disCtrlView, animated: true)
    }
    
}

extension RegistrationViewController: TextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboards()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismissKeyboards()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
