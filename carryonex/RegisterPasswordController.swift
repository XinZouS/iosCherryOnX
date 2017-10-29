//
//  RegisterPasswordController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import Material


class RegisterPasswordController: UIViewController {
    var passwordField: TextField!
    var passwordConfirmField: TextField!
    var passwordCorrect : Bool = false
    fileprivate let constant: CGFloat = 32
    
    lazy var okButton: UIButton = {
        let b = UIButton()
        b.setTitle("→", for: .normal)
        b.layer.cornerRadius = 30
        b.backgroundColor = .lightGray
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        b.isEnabled = false
        return b
    }()
    fileprivate func prepareResignResponderButton() {
        let btn = RaisedButton(title: "Resign", titleColor: Color.blue.base)
        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        
        view.layout(btn).width(100).height(constant).top(40).right(20)
    }
    
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        passwordField?.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordField.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPasswordTextField()
        
        
        setupPasswordConfirmTextField()
        
        
        setupOkButton()
        
    }
    private func setupPasswordTextField(){
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.detail = "At least 6 characters"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.keyboardAppearance = .dark
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        let leftView = UIImageView()
        leftView.image = Icon.settings
        passwordField.leftView = leftView
        passwordField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        view.layout(passwordField).top(200).left(60).right(60)
    }
    
    
    private func setupPasswordConfirmTextField(){
        passwordConfirmField = TextField()
        passwordConfirmField.placeholder = "confirm"
        passwordConfirmField.detail = "Confirm your password"
        passwordConfirmField.clearButtonMode = .whileEditing
        passwordConfirmField.isVisibilityIconButtonEnabled = true
        // Setting the visibilityIconButton color.
        passwordConfirmField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        passwordConfirmField.addTarget(self, action: #selector(checkConfirmPassword), for: .editingChanged)
        let leftView = UIImageView()
        leftView.image = Icon.settings
        passwordConfirmField.leftView = leftView
        
        view.layout(passwordConfirmField).center().left(60).right(60)
    }
    
    
    private func setupOkButton(){
        view.addSubview(okButton)
        okButton.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 30, width: 60, height: 60)
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
    }
}
