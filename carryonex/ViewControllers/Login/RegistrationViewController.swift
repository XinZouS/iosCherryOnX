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
    
    @IBOutlet weak var nameField: TextField!
    @IBOutlet weak var phoneField: TextField!
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var confirmPasswordField: TextField!
    
    @IBOutlet weak var backButton: Button!
    @IBOutlet weak var registerButton: Button!
    @IBOutlet weak var agreeButton: Button!
    @IBOutlet weak var countryCodeButton: Button!
    
    
    var countryCode = "1"
    var isPhoneNumValid = false {
        didSet {
            checkRegistrationButtonReady()
        }
    }
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
        phoneField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        nameField.keyboardType = .default
        phoneField.keyboardType = .numberPad
        passwordField.keyboardType = .default
        confirmPasswordField.keyboardType = .default
        
        nameField.addTarget(self, action: #selector(checkRegistrationButtonReady), for: .editingChanged)
        phoneField.addTarget(self, action: #selector(checkPhoneNumFormat), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(isPasswordValidate), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(isPasswordValidate), for: .editingChanged)
    }

    
    
    @IBAction func handleRegisterButton(sender: UIButton) {
        
        guard let name = nameField.text else {
            nameField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            nameField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            nameField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            AudioManager.shared.playSond(named: .failed)
            return
        }
                
        guard let phone = phoneField.text else {
            phoneField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            phoneField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            phoneField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            isPhoneNumValid = false
            AudioManager.shared.playSond(named: .failed)
            return
        }
        
        if !isPasswordValidate() {
            AudioManager.shared.playSond(named: .failed)
            return
        }
        
        guard isPasswordValid && isPhoneNumValid else { 
            AudioManager.shared.playSond(named: .failed)
            return 
        }
        
        guard let password = passwordField.text else { 
            AudioManager.shared.playSond(named: .failed)
            return 
        }
        
        ApiServers.shared.getIsUserExisted(phoneInput: phone) { (isExist, error) in
            if let error = error {
                let e = "注册出现错误，请稍后再试一次。\n错误: \(error.localizedDescription)"
                self.displayGlobalAlert(title: "⚠️不能注册", message: e, action: "好", completion: nil)
                return
            }
            if isExist {
                let m = "您所使用的手机号 \(phone) 已注册，请使用密码登陆即可。"
                self.displayGlobalAlert(title: "💡用户已存在", message: m, action: "去登陆", completion: {
                    self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                let info: [String:String] = [
                    "realName" : name,
                    "countryCode" : self.countryCode,
                    "phone" : phone,
                    "password" : password,
                ]
                self.performSegue(withIdentifier: "gotoPhoneVerifyVC", sender: info)
            }
        }
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
        phoneField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()
    }
    
    private func isPasswordPatternValidate(textField: TextField) -> Bool {
        guard let pw = textField.text, pw != "" else { return false }
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)

        return matcher.match(input: pw)
    }
    
    func isPasswordValidate() -> Bool {
        guard let password = passwordField.text, let confirm = confirmPasswordField.text, password != "", confirm != "" else {
            passwordField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            passwordField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            passwordField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            
            confirmPasswordField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            confirmPasswordField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            confirmPasswordField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            AudioManager.shared.playSond(named: .failed)
            isPasswordValid = false
            return false
        }
        isPasswordValid = isPasswordPatternValidate(textField: passwordField) && password == confirm
        
        return isPasswordValid
    }
    
    func checkPhoneNumFormat(){
        var phonePattern = ""
        switch countryCode {
        case "86":
            phonePattern = "^1[0-9]{10}$"
        case "1":
            phonePattern = "^[0-9]{10}$"
        default:
            phonePattern = "^[0-9]{10}$"
        }
        let matcher = MyRegex(phonePattern)
        let phoneInput = phoneField.text ?? ""
        
        let isFormatOK = matcher.match(input: phoneInput)
        
        phoneField.leftViewActiveColor    = isFormatOK ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        phoneField.dividerActiveColor     = isFormatOK ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        phoneField.placeholderActiveColor = isFormatOK ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
        isPhoneNumValid = isFormatOK

        let msg = isFormatOK ? "电话格式正确" : "电话格式有误"
        print(msg + ": \(countryCode) \(phoneInput)")
    }

    func checkRegistrationButtonReady() {
        let nameOk = (nameField.text != nil && nameField.text != "")
        let ok = isPasswordValid && isPhoneNumValid && nameOk
        registerButton.isEnabled = ok
        registerButton.backgroundColor  = ok ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        registerButton.titleColor       = ok ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
