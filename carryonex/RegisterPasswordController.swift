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
        _ = passwordField.becomeFirstResponder()
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
        passwordField.placeholder = "密码"
        passwordField.detail = "请输入最少6位密码"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.keyboardAppearance = .dark
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        let leftView = UIImageView()
        leftView.image = Icon.settings
        passwordField.leftView = leftView
        passwordField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        passwordField.placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        view.layout(passwordField).top(200).left(60).right(60)
    }
    
    
    private func setupPasswordConfirmTextField(){
        passwordConfirmField = TextField()
        passwordConfirmField.placeholder = "确认"
        passwordConfirmField.detail = "请确认你的密码"
        passwordConfirmField.clearButtonMode = .whileEditing
        passwordConfirmField.keyboardAppearance = .dark
        passwordConfirmField.isVisibilityIconButtonEnabled = true
        // Setting the visibilityIconButton color.
        passwordConfirmField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        passwordConfirmField.addTarget(self, action: #selector(checkConfirmPassword), for: .editingChanged)
        let leftView = UIImageView()
        leftView.image = Icon.settings
        passwordConfirmField.leftView = leftView
        passwordConfirmField.placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        view.layout(passwordConfirmField).center().left(60).right(60)
    }
    
    
    private func setupOkButton(){
        var h = 0,w = 0
        switch UIScreen.main.bounds.width {
        case 320:
            h = 30
            w = 130
        case 375:
            h = 80
            w = 150
        case 414:
            h = 100
            w = 170
        default:
            h = 100
            w = 170
        }
        view.addSubview(okButton)
        okButton.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 30, width: 60, height: 60)
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: CGFloat(w)).isActive = true
        okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(h)).isActive = true
    }
}
