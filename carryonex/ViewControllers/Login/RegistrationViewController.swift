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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func setupTextFields() {
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
            return
        }
        
        guard let phone = phoneField.text else {
            phoneField.leftViewActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            phoneField.dividerActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            phoneField.placeholderActiveColor = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
            isPhoneNumValid = false
            return
        }
        
        if !isPasswordValidate() {
            return
        }
        
        guard isPasswordValid && isPhoneNumValid else { return }
        
        guard let password = passwordField.text else { return }
        ProfileManager.shared.register(username: phone,
                                       countryCode: countryCode,
                                       phone: phone,
                                       password: password,
                                       name: name,
                                       completion: { (success, m, tag) in
            if success {
                self.performSegue(withIdentifier: "gotoPhoneVerifyVC", sender: self)
            } else {
                let e1 = "您所使用的手机号已注册，请使用密码登陆即可。"
                let e2 = "注册出现错误，请确保所填信息正确，稍后再试一次。\n错误: \(m)"
                let msg = tag == 1 ? e1 : e2
                self.displayGlobalAlert(title: "⚠️不能注册", message: msg, action: "好", completion: { () in
                    if tag == 1 { // user already exist, go back to login
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        })
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
