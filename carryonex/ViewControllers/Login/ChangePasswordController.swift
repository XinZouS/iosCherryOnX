//
//  ChangePasswordController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/24.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class ChangePasswordController: UIViewController{
    
    var registerUserInfo : [String:String]?
    var zoneCodeInput :String = "1"
    var phoneInput :String = ""
    
    @IBOutlet weak var passwordTextField: ThemTextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var bottomImageView: UIImageView!
    
    override func viewDidLoad() {
        zoneCodeInput = registerUserInfo?["countryCode"] ?? "1"
        phoneInput = registerUserInfo?["phone"] ?? ""
        setupPasswordTextField()
        setupGifImageView()
        setupButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }
    
    private func setupPasswordTextField(){
        passwordTextField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        passwordTextField.isSecureTextEntry = true
    }
    
    private func setupGifImageView(){
        let gifImg = UIImage.gifImageWithName("Login_animated_loop_png")
        bottomImageView.image = gifImg
    }
    
    private func setupButton() {
        changePasswordButton.layer.masksToBounds = true
        changePasswordButton.layer.borderColor = colorTheamRed.cgColor
        changePasswordButton.layer.borderWidth = 2
        changePasswordButton.layer.cornerRadius = 6
        changePasswordButton.backgroundColor = .white
        changePasswordButton.setTitleColor(colorTheamRed, for: .normal)
    }

    
    @objc private func checkPassword(){
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)
        
        if let maybePassword = passwordTextField.text {
            let isMatch = matcher.match(input: maybePassword)
            changePasswordButton.setTitleColor((isMatch ? .white : colorTheamRed), for: .normal)
            changePasswordButton.backgroundColor = isMatch ? colorTheamRed : .white
            changePasswordButton.isEnabled = isMatch
            let msg = isMatch ? "密码正确" : "密码错误"
            DLog(msg)
        } else {
            changePasswordButton.isEnabled = false
            changePasswordButton.backgroundColor = .white
        }
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        let newPassword = passwordTextField.text
        ProfileManager.shared.forgetPassword(phone: phoneInput, password: newPassword!) { (success, error) in
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                DLog(error?.localizedDescription ?? "")
            }
        }
    }
}
